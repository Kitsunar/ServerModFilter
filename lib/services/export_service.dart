import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import '../models/mod_info.dart';
import '../models/analysis_result.dart';

/// Service qui crée le dossier mods serveur à partir de l'analyse.
class ExportService {
  /// Crée un dossier avec uniquement les mods serveur.
  /// Retourne le chemin du dossier créé.
  Future<String> exportServerMods({
    required AnalysisResult analysis,
    required String outputPath,
    Function(double progress, String currentMod)? onProgress,
  }) async {
    final serverMods = analysis.serverMods;
    final modsDir = Directory(p.join(outputPath, 'mods'));

    if (!await modsDir.exists()) {
      await modsDir.create(recursive: true);
    }

    for (int i = 0; i < serverMods.length; i++) {
      final mod = serverMods[i];
      onProgress?.call(
        (i + 1) / serverMods.length,
        mod.displayName,
      );

      final sourceFile = File(p.join(analysis.sourcePath, mod.fileName));
      if (await sourceFile.exists()) {
        final destFile = File(p.join(modsDir.path, mod.fileName));
        await sourceFile.copy(destFile.path);
      }
    }

    // Générer un rapport
    await _generateReport(analysis, outputPath);

    return modsDir.path;
  }

  /// Exporte les mods serveur dans un fichier .zip.
  Future<String> exportServerModsAsZip({
    required AnalysisResult analysis,
    required String outputZipPath,
    Function(double progress, String currentMod)? onProgress,
  }) async {
    final serverMods = analysis.serverMods;
    final encoder = ZipEncoder();
    final archive = Archive();

    for (int i = 0; i < serverMods.length; i++) {
      final mod = serverMods[i];
      onProgress?.call(
        (i + 1) / serverMods.length,
        mod.displayName,
      );

      final sourceFile = File(p.join(analysis.sourcePath, mod.fileName));
      if (await sourceFile.exists()) {
        final bytes = await sourceFile.readAsBytes();
        archive.addFile(ArchiveFile(
          'mods/${mod.fileName}',
          bytes.length,
          bytes,
        ));
      }
    }

    final zipBytes = encoder.encode(archive);
    if (zipBytes != null) {
      final outFile = File(outputZipPath);
      await outFile.writeAsBytes(zipBytes);
    }

    return outputZipPath;
  }

  /// Génère un rapport texte de l'analyse.
  Future<void> _generateReport(AnalysisResult analysis, String outputPath) async {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════════════════');
    buffer.writeln('  ServerModFilter - Rapport d\'analyse');
    buffer.writeln('═══════════════════════════════════════════════════');
    buffer.writeln('Date : ${analysis.analyzedAt}');
    buffer.writeln('Loader : ${analysis.selectedLoader.name}');
    buffer.writeln('Source : ${analysis.sourcePath}');
    buffer.writeln('');
    buffer.writeln(analysis.summary);
    buffer.writeln('');

    void writeMods(String title, List<ModInfo> mods) {
      buffer.writeln('── $title (${ mods.length}) ──');
      for (final mod in mods) {
        buffer.writeln('  • ${mod.displayName} (${mod.formattedSize})');
        if (mod.detectionReasons.isNotEmpty) {
          buffer.writeln('    Raison: ${mod.detectionReasons.join(', ')}');
        }
      }
      buffer.writeln('');
    }

    writeMods('🟢 Client & Serveur (gardés)', analysis.bothSides);
    writeMods('🔵 Serveur uniquement (gardés)', analysis.serverOnly);
    writeMods('🔴 Client uniquement (retirés)', analysis.clientOnly);
    writeMods('🟡 Inconnu (gardés par sécurité)', analysis.unknown);

    final reportFile = File(p.join(outputPath, 'ServerModFilter_rapport.txt'));
    await reportFile.writeAsString(buffer.toString());
  }
}
