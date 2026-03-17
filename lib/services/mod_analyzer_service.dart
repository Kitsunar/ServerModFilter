import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import '../models/mod_info.dart';
import '../models/analysis_result.dart';
import 'known_mods_database.dart';

/// Service qui analyse les fichiers .jar pour déterminer le côté de chaque mod.
class ModAnalyzerService {
  final KnownModsDatabase _knownMods = KnownModsDatabase();

  /// Analyse un dossier ou un fichier .zip contenant des mods.
  /// [inputPath] peut être un dossier ou un .zip.
  /// [selectedLoader] est le modloader choisi par l'utilisateur.
  /// [onProgress] callback pour la progression (0.0 à 1.0).
  Future<AnalysisResult> analyze({
    required String inputPath,
    required ModLoader selectedLoader,
    Function(double progress, String currentMod)? onProgress,
  }) async {
    final List<File> jarFiles = await _collectJarFiles(inputPath);
    final List<ModInfo> results = [];

    for (int i = 0; i < jarFiles.length; i++) {
      final file = jarFiles[i];
      final fileName = p.basename(file.path);

      onProgress?.call(
        (i + 1) / jarFiles.length,
        fileName,
      );

      try {
        final modInfo = await _analyzeJar(file, selectedLoader);
        results.add(modInfo);
      } catch (e) {
        // Si l'analyse échoue, on ajoute quand même le mod comme "unknown"
        results.add(ModInfo(
          fileName: fileName,
          side: ModSide.unknown,
          detectedLoader: selectedLoader,
          confidence: DetectionConfidence.low,
          fileSizeBytes: await file.length(),
          detectionReasons: ['Erreur d\'analyse: $e'],
        ));
      }
    }

    // Déterminer le vrai dossier source des .jar
    final actualSourcePath = jarFiles.isNotEmpty
        ? jarFiles.first.parent.path
        : inputPath;

    return AnalysisResult(
      mods: results,
      selectedLoader: selectedLoader,
      analyzedAt: DateTime.now(),
      sourcePath: actualSourcePath,
    );
  }

  /// Collecte tous les .jar depuis un dossier ou un .zip.
  Future<List<File>> _collectJarFiles(String inputPath) async {
    final entity = FileSystemEntity.typeSync(inputPath);

    if (entity == FileSystemEntityType.directory) {
      // C'est un dossier : lister les .jar
      final dir = Directory(inputPath);
      return dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.jar'))
          .toList();
    } else if (entity == FileSystemEntityType.file &&
        inputPath.toLowerCase().endsWith('.zip')) {
      // C'est un .zip : extraire les .jar dans un dossier temporaire
      return await _extractJarsFromZip(inputPath);
    }

    throw Exception('Le chemin doit être un dossier ou un fichier .zip');
  }

  /// Extrait les .jar d'un fichier .zip.
  Future<List<File>> _extractJarsFromZip(String zipPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tempDir = await Directory.systemTemp.createTemp('smf_');
    final jarFiles = <File>[];

    for (final file in archive.files) {
      if (file.isFile && file.name.toLowerCase().endsWith('.jar')) {
        final outFile = File(p.join(tempDir.path, p.basename(file.name)));
        await outFile.writeAsBytes(file.content as List<int>);
        jarFiles.add(outFile);
      }
    }

    return jarFiles;
  }

  /// Analyse un seul fichier .jar.
  Future<ModInfo> _analyzeJar(File jarFile, ModLoader selectedLoader) async {
    final bytes = await jarFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final fileName = p.basename(jarFile.path);
    final fileSize = await jarFile.length();

    // 1. Vérifier la base de données de mods connus
    final knownSide = _knownMods.lookup(fileName);
    if (knownSide != null) {
      return ModInfo(
        fileName: fileName,
        side: knownSide,
        detectedLoader: selectedLoader,
        confidence: DetectionConfidence.high,
        fileSizeBytes: fileSize,
        detectionReasons: ['Mod reconnu dans la base de données'],
      );
    }

    // 2. Analyser selon le modloader
    switch (selectedLoader) {
      case ModLoader.forge:
      case ModLoader.neoforge:
        return _analyzeForgeNeoForge(archive, fileName, fileSize, selectedLoader);
      case ModLoader.fabric:
        return _analyzeFabric(archive, fileName, fileSize);
      case ModLoader.quilt:
        return _analyzeQuilt(archive, fileName, fileSize);
      default:
        return _analyzeFallback(archive, fileName, fileSize, selectedLoader);
    }
  }

  /// Analyse un mod Forge / NeoForge via mods.toml.
  ModInfo _analyzeForgeNeoForge(
    Archive archive,
    String fileName,
    int fileSize,
    ModLoader loader,
  ) {
    String? modId;
    String? modName;
    String? version;
    String? description;
    ModSide side = ModSide.unknown;
    DetectionConfidence confidence = DetectionConfidence.low;
    final reasons = <String>[];

    // Chercher META-INF/mods.toml
    final modsToml = _findFile(archive, 'META-INF/mods.toml');
    if (modsToml != null) {
      final content = utf8.decode(modsToml.content as List<int>, allowMalformed: true);

      // Extraire le modId
      modId = _extractTomlValue(content, 'modId');
      modName = _extractTomlValue(content, 'displayName');
      version = _extractTomlValue(content, 'version');
      description = _extractTomlValue(content, 'description');

      // Chercher le champ "side" dans les dépendances [[dependencies.modid]]
      final sideValue = _extractTomlSide(content);
      if (sideValue != null) {
        side = _parseSideString(sideValue);
        confidence = DetectionConfidence.high;
        reasons.add('Champ "side" trouvé dans mods.toml: $sideValue');
      }
    }

    // 3. Fallback : analyse des classes
    if (side == ModSide.unknown) {
      final classSide = _analyzeClassNames(archive);
      side = classSide.side;
      confidence = classSide.confidence;
      reasons.addAll(classSide.reasons);
    }

    return ModInfo(
      fileName: fileName,
      modId: modId,
      modName: modName,
      version: version,
      description: description,
      side: side,
      detectedLoader: loader,
      confidence: confidence,
      fileSizeBytes: fileSize,
      detectionReasons: reasons,
    );
  }

  /// Analyse un mod Fabric via fabric.mod.json.
  ModInfo _analyzeFabric(Archive archive, String fileName, int fileSize) {
    String? modId;
    String? modName;
    String? version;
    String? description;
    ModSide side = ModSide.unknown;
    DetectionConfidence confidence = DetectionConfidence.low;
    final reasons = <String>[];
    final deps = <String>[];

    final fabricJson = _findFile(archive, 'fabric.mod.json');
    if (fabricJson != null) {
      try {
        final content = utf8.decode(fabricJson.content as List<int>, allowMalformed: true);
        final json = jsonDecode(content) as Map<String, dynamic>;

        modId = json['id'] as String?;
        modName = json['name'] as String?;
        version = json['version'] as String?;
        description = json['description'] as String?;

        // Fabric utilise "environment" pour le côté
        final env = json['environment'] as String?;
        if (env != null) {
          if (env == 'client') {
            side = ModSide.client;
            confidence = DetectionConfidence.high;
            reasons.add('environment: "client" dans fabric.mod.json');
          } else if (env == 'server') {
            side = ModSide.server;
            confidence = DetectionConfidence.high;
            reasons.add('environment: "server" dans fabric.mod.json');
          } else if (env == '*') {
            side = ModSide.both;
            confidence = DetectionConfidence.high;
            reasons.add('environment: "*" dans fabric.mod.json');
          }
        }

        // Extraire les dépendances
        final depends = json['depends'] as Map<String, dynamic>?;
        if (depends != null) {
          deps.addAll(depends.keys);
        }
      } catch (_) {
        reasons.add('Erreur de parsing de fabric.mod.json');
      }
    }

    // Fallback classes
    if (side == ModSide.unknown) {
      final classSide = _analyzeClassNames(archive);
      side = classSide.side;
      confidence = classSide.confidence;
      reasons.addAll(classSide.reasons);
    }

    return ModInfo(
      fileName: fileName,
      modId: modId,
      modName: modName,
      version: version,
      description: description,
      side: side,
      detectedLoader: ModLoader.fabric,
      confidence: confidence,
      dependencies: deps,
      fileSizeBytes: fileSize,
      detectionReasons: reasons,
    );
  }

  /// Analyse un mod Quilt via quilt.mod.json.
  ModInfo _analyzeQuilt(Archive archive, String fileName, int fileSize) {
    String? modId;
    String? modName;
    String? version;
    String? description;
    ModSide side = ModSide.unknown;
    DetectionConfidence confidence = DetectionConfidence.low;
    final reasons = <String>[];

    final quiltJson = _findFile(archive, 'quilt.mod.json');
    if (quiltJson != null) {
      try {
        final content = utf8.decode(quiltJson.content as List<int>, allowMalformed: true);
        final json = jsonDecode(content) as Map<String, dynamic>;

        final loader = json['quilt_loader'] as Map<String, dynamic>?;
        if (loader != null) {
          modId = loader['id'] as String?;
          version = loader['version'] as String?;
          final meta = loader['metadata'] as Map<String, dynamic>?;
          if (meta != null) {
            modName = meta['name'] as String?;
            description = meta['description'] as String?;
          }
        }

        // Quilt utilise "minecraft.environment"
        final mc = json['minecraft'] as Map<String, dynamic>?;
        if (mc != null) {
          final env = mc['environment'] as String?;
          if (env != null) {
            if (env == 'client') {
              side = ModSide.client;
              confidence = DetectionConfidence.high;
              reasons.add('minecraft.environment: "client" dans quilt.mod.json');
            } else if (env == 'dedicated_server') {
              side = ModSide.server;
              confidence = DetectionConfidence.high;
              reasons.add('minecraft.environment: "dedicated_server" dans quilt.mod.json');
            } else if (env == '*') {
              side = ModSide.both;
              confidence = DetectionConfidence.high;
              reasons.add('minecraft.environment: "*" dans quilt.mod.json');
            }
          }
        }
      } catch (_) {
        reasons.add('Erreur de parsing de quilt.mod.json');
      }
    } else {
      // Quilt est compatible Fabric, essayer fabric.mod.json
      return _analyzeFabric(archive, fileName, fileSize);
    }

    if (side == ModSide.unknown) {
      final classSide = _analyzeClassNames(archive);
      side = classSide.side;
      confidence = classSide.confidence;
      reasons.addAll(classSide.reasons);
    }

    return ModInfo(
      fileName: fileName,
      modId: modId,
      modName: modName,
      version: version,
      description: description,
      side: side,
      detectedLoader: ModLoader.quilt,
      confidence: confidence,
      fileSizeBytes: fileSize,
      detectionReasons: reasons,
    );
  }

  /// Fallback pour loader inconnu.
  ModInfo _analyzeFallback(
    Archive archive,
    String fileName,
    int fileSize,
    ModLoader loader,
  ) {
    final classSide = _analyzeClassNames(archive);
    return ModInfo(
      fileName: fileName,
      side: classSide.side,
      detectedLoader: loader,
      confidence: classSide.confidence,
      fileSizeBytes: fileSize,
      detectionReasons: classSide.reasons,
    );
  }

  // ---------------------------------------------------------------------------
  // Utilitaires d'analyse
  // ---------------------------------------------------------------------------

  /// Analyse heuristique des noms de classes dans le .jar.
  _ClassAnalysisResult _analyzeClassNames(Archive archive) {
    bool hasClientClasses = false;
    bool hasServerClasses = false;
    final reasons = <String>[];

    // Patterns indiquant du code client
    final clientPatterns = [
      'client/',
      'Client.',
      '/client/',
      '/render/',
      '/gui/',
      '/screen/',
      '/renderer/',
      'Renderer.',
      'Screen.',
      'Gui.',
      'Hud.',
      '/hud/',
      'KeyBinding',
      'ShaderPack',
    ];

    // Patterns indiquant du code serveur
    final serverPatterns = [
      'server/',
      'Server.',
      '/server/',
      '/command/',
      'Command.',
      '/data/',
      'ServerLevel',
      'ServerPlayer',
    ];

    for (final file in archive.files) {
      if (!file.isFile) continue;
      final name = file.name;

      for (final pattern in clientPatterns) {
        if (name.contains(pattern)) {
          hasClientClasses = true;
          break;
        }
      }
      for (final pattern in serverPatterns) {
        if (name.contains(pattern)) {
          hasServerClasses = true;
          break;
        }
      }
    }

    ModSide side;
    DetectionConfidence confidence = DetectionConfidence.medium;

    if (hasClientClasses && hasServerClasses) {
      side = ModSide.both;
      reasons.add('Classes client ET serveur détectées');
    } else if (hasClientClasses && !hasServerClasses) {
      side = ModSide.client;
      reasons.add('Uniquement des classes client détectées');
    } else if (!hasClientClasses && hasServerClasses) {
      side = ModSide.server;
      reasons.add('Uniquement des classes serveur détectées');
    } else {
      side = ModSide.both; // Par défaut, on considère "both" par sécurité
      confidence = DetectionConfidence.low;
      reasons.add('Aucun pattern client/serveur clair, classé en "les deux" par défaut');
    }

    return _ClassAnalysisResult(side: side, confidence: confidence, reasons: reasons);
  }

  /// Cherche un fichier dans l'archive (insensible à la casse pour le nom).
  ArchiveFile? _findFile(Archive archive, String path) {
    for (final file in archive.files) {
      if (file.name == path || file.name == '/$path') {
        return file;
      }
    }
    return null;
  }

  /// Extrait une valeur simple d'un fichier TOML (parsing basique).
  String? _extractTomlValue(String content, String key) {
    final regex = RegExp('$key\\s*=\\s*"([^"]*)"');
    final match = regex.firstMatch(content);
    return match?.group(1);
  }

  /// Extrait le champ "side" des dépendances dans mods.toml.
  String? _extractTomlSide(String content) {
    // Cherche : side = "CLIENT" / "SERVER" / "BOTH"
    final regex = RegExp(r'side\s*=\s*"([^"]*)"', caseSensitive: false);
    final matches = regex.allMatches(content);

    // On prend le premier "side" qui n'est pas "BOTH" pour la dep minecraft
    for (final match in matches) {
      final value = match.group(1)?.toUpperCase();
      if (value != null) return value;
    }
    return null;
  }

  /// Convertit une string "CLIENT"/"SERVER"/"BOTH" en ModSide.
  ModSide _parseSideString(String value) {
    switch (value.toUpperCase()) {
      case 'CLIENT':
        return ModSide.client;
      case 'SERVER':
        return ModSide.server;
      case 'BOTH':
        return ModSide.both;
      default:
        return ModSide.unknown;
    }
  }
}

class _ClassAnalysisResult {
  final ModSide side;
  final DetectionConfidence confidence;
  final List<String> reasons;

  _ClassAnalysisResult({
    required this.side,
    required this.confidence,
    required this.reasons,
  });
}
