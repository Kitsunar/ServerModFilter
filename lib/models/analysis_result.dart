import 'mod_info.dart';

/// Résultat complet d'une analyse de mods.
class AnalysisResult {
  final List<ModInfo> mods;
  final ModLoader selectedLoader;
  final DateTime analyzedAt;
  final String sourcePath;

  const AnalysisResult({
    required this.mods,
    required this.selectedLoader,
    required this.analyzedAt,
    required this.sourcePath,
  });

  /// Mods uniquement client.
  List<ModInfo> get clientOnly =>
      mods.where((m) => m.side == ModSide.client).toList();

  /// Mods uniquement serveur.
  List<ModInfo> get serverOnly =>
      mods.where((m) => m.side == ModSide.server).toList();

  /// Mods client ET serveur.
  List<ModInfo> get bothSides =>
      mods.where((m) => m.side == ModSide.both).toList();

  /// Mods dont le côté est inconnu.
  List<ModInfo> get unknown =>
      mods.where((m) => m.side == ModSide.unknown).toList();

  /// Nombre total de mods.
  int get totalCount => mods.length;

  /// Mods qui devraient aller sur le serveur (server + both).
  List<ModInfo> get serverMods {
    return mods
        .where((m) => m.side == ModSide.server || m.side == ModSide.both)
        .toList();
  }

  /// Statistiques rapides.
  String get summary {
    return '$totalCount mods : ${clientOnly.length} client, '
        '${serverOnly.length} serveur, ${bothSides.length} les deux, '
        '${unknown.length} inconnu(s)';
  }
}
