/// Représente le côté (side) d'un mod Minecraft.
enum ModSide {
  client,       // Uniquement côté client (ex: shaders, HUD mods)
  server,       // Uniquement côté serveur
  both,         // Client ET serveur
  unknown,      // Impossible à déterminer automatiquement
}

/// Représente le modloader ciblé.
enum ModLoader {
  forge,
  neoforge,
  fabric,
  quilt,
  unknown,
}

/// Niveau de confiance de la détection.
enum DetectionConfidence {
  high,    // Trouvé dans les métadonnées officielles
  medium,  // Déduit par analyse des classes/packages
  low,     // Heuristique basée sur le nom ou base de données
}

/// Modèle principal représentant un mod analysé.
class ModInfo {
  final String fileName;
  final String? modId;
  final String? modName;
  final String? version;
  final String? description;
  final String? minecraftVersion;
  final ModSide side;
  final ModLoader detectedLoader;
  final DetectionConfidence confidence;
  final List<String> dependencies;
  final int fileSizeBytes;
  final List<String> detectionReasons;

  const ModInfo({
    required this.fileName,
    this.modId,
    this.modName,
    this.version,
    this.description,
    this.minecraftVersion,
    required this.side,
    required this.detectedLoader,
    required this.confidence,
    this.dependencies = const [],
    required this.fileSizeBytes,
    this.detectionReasons = const [],
  });

  /// Nom d'affichage : le modName si disponible, sinon le fileName.
  String get displayName => modName ?? fileName;

  /// Taille formatée en Ko/Mo.
  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} Ko';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  /// Le label du côté en français.
  String get sideLabel {
    switch (side) {
      case ModSide.client:
        return 'Client uniquement';
      case ModSide.server:
        return 'Serveur uniquement';
      case ModSide.both:
        return 'Client & Serveur';
      case ModSide.unknown:
        return 'Inconnu';
    }
  }

  /// Crée une copie avec un side modifié (pour correction manuelle).
  ModInfo copyWithSide(ModSide newSide) {
    return ModInfo(
      fileName: fileName,
      modId: modId,
      modName: modName,
      version: version,
      description: description,
      minecraftVersion: minecraftVersion,
      side: newSide,
      detectedLoader: detectedLoader,
      confidence: confidence,
      dependencies: dependencies,
      fileSizeBytes: fileSizeBytes,
      detectionReasons: [...detectionReasons, 'Modifié manuellement'],
    );
  }
}
