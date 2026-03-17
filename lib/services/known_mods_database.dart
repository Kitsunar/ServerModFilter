import '../models/mod_info.dart';

/// Base de données locale de mods connus et leur côté.
/// Permet une détection rapide sans avoir à analyser le .jar.
class KnownModsDatabase {
  /// Recherche un mod par nom de fichier.
  /// Retourne le [ModSide] si trouvé, null sinon.
  ModSide? lookup(String fileName) {
    final lower = fileName.toLowerCase();

    // Vérifier les patterns de mods client-only connus
    for (final pattern in _clientOnlyPatterns) {
      if (lower.contains(pattern)) {
        return ModSide.client;
      }
    }

    // Vérifier les patterns de mods serveur-only connus
    for (final pattern in _serverOnlyPatterns) {
      if (lower.contains(pattern)) {
        return ModSide.server;
      }
    }

    return null;
  }

  // ---- Mods client-only bien connus ----
  static const _clientOnlyPatterns = [
    // Shaders & rendu
    'optifine',
    'oculus',
    'iris',
    'sodium',
    'rubidium',
    'embeddium',
    'magnesium',
    'indium',

    // HUD & interface
    'journeymap',
    'xaeros-minimap',
    'xaerominimap',
    'xaeros_minimap',
    'xaeros-world-map',
    'xaerosworldmap',
    'voxelmap',
    'rei-',           // Roughly Enough Items (client)
    'jei-',           // Just Enough Items (aussi client-side rendering)
    'emi-',           // EMI
    'appleskin',
    'jade-',          // WAILA/Jade (overlay client)
    'wthit',          // WAILA fork
    'hwyla',
    'torohealth',
    'neat',           // Health bars au-dessus des mobs

    // Performance client
    'entityculling',
    'entity-culling',
    'ferritecore',    // Note: aussi utile serveur, mais souvent classé client
    'smoothboot',
    'lazydfu',
    'starlight',
    'modernfix',
    'betterfps',
    'fpsreducer',

    // Visuels & cosmétiques
    'betterfoliage',
    'dynamiclights',
    'lambdynlights',
    'soundphysics',
    'presencefootsteps',
    'effective',       // Effets visuels (cascades, etc.)
    'falling-leaves',
    'not-enough-animations',
    'camerautils',
    'better-third-person',
    'betterthirdperson',

    // Utilitaires client
    'modmenu',
    'controlling',
    'configured',
    'catalogue',
    'toast-control',
    'tipthescales',
    'screenshot-to-clipboard',
    'screenshottoclipboard',
    'mouse-tweaks',
    'itemzoom',
    'light-overlay',
    'shulkerboxtooltip',
    'inventory-hud',
    'inventoryhud',
    'betterf3',

    // Chat & social client
    'chathead',
    'chat-heads',
    'emojiful',
  ];

  // ---- Mods serveur-only bien connus ----
  static const _serverOnlyPatterns = [
    'luckperms',
    'worldedit',       // A aussi une version client, mais côté serveur principalement
    'worldguard',
    'essentials',
    'griefprevention',
    'chunky',          // Pre-generation
    'spark',           // Profiler (aussi client mais principalement serveur)
  ];
}
