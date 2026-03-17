import 'package:flutter/material.dart';

/// Thème inspiré de Minecraft pour ServerModFilter.
class MinecraftTheme {
  // ── Couleurs principales ──
  static const Color dirt = Color(0xFF3C2415);         // Marron terre
  static const Color dirtLight = Color(0xFF6B4226);    // Terre claire
  static const Color stone = Color(0xFF7F7F7F);        // Pierre
  static const Color stoneDark = Color(0xFF4A4A4A);    // Pierre sombre
  static const Color grass = Color(0xFF5D9B47);        // Herbe
  static const Color grassDark = Color(0xFF3B6E2A);    // Herbe foncée
  static const Color obsidian = Color(0xFF1A1024);     // Fond principal
  static const Color deepslate = Color(0xFF2C2C34);    // Fond secondaire
  static const Color bedrock = Color(0xFF121218);       // Fond le plus sombre

  // ── Couleurs d'accent ──
  static const Color emerald = Color(0xFF17DD62);      // Vert émeraude
  static const Color diamond = Color(0xFF2EC4CF);      // Bleu diamant
  static const Color redstone = Color(0xFFD94040);     // Rouge redstone
  static const Color gold = Color(0xFFFCAC2F);         // Or
  static const Color enchant = Color(0xFFA855F7);      // Violet enchantement
  static const Color lapis = Color(0xFF3456D1);        // Bleu lapis

  // ── Couleurs pour les catégories de mods ──
  static const Color clientColor = Color(0xFF2EC4CF);   // Diamant
  static const Color serverColor = Color(0xFFFCAC2F);   // Or
  static const Color bothColor = Color(0xFF17DD62);     // Émeraude
  static const Color unknownColor = Color(0xFFD94040);  // Redstone

  // ── Texte ──
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  /// Le ThemeData complet pour l'app.
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bedrock,
      primaryColor: emerald,
      colorScheme: const ColorScheme.dark(
        primary: emerald,
        secondary: diamond,
        surface: deepslate,
        error: redstone,
        onPrimary: bedrock,
        onSecondary: bedrock,
        onSurface: textPrimary,
        onError: textPrimary,
      ),

      // AppBar style
      appBarTheme: const AppBarTheme(
        backgroundColor: obsidian,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: deepslate,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Pixelisé = angles droits
          side: const BorderSide(color: stoneDark, width: 2),
        ),
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: grass,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: grassDark, width: 2),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: stone, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: emerald,
        linearTrackColor: stoneDark,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: stoneDark,
        thickness: 2,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: obsidian,
          border: Border.all(color: stone, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        textStyle: const TextStyle(color: textPrimary, fontSize: 12),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 15,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
        ),
      ),
    );
  }

  // ── Décorations réutilisables ──

  /// Bordure style Minecraft (ombre en bas à droite).
  static BoxDecoration get minecraftBox => BoxDecoration(
        color: deepslate,
        border: Border.all(color: stoneDark, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      );

  /// Bordure de bouton style Minecraft avec effet 3D.
  static BoxDecoration minecraftButton({Color color = grass}) {
    final darker = Color.lerp(color, Colors.black, 0.3) ?? color;
    final lighter = Color.lerp(color, Colors.white, 0.2) ?? color;
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
      border: Border(
        top: BorderSide(color: lighter, width: 2),
        left: BorderSide(color: lighter, width: 2),
        right: BorderSide(color: darker, width: 2),
        bottom: BorderSide(color: darker, width: 2),
      ),
    );
  }

  /// Couleur associée à un ModSide.
  static Color colorForSide(String side) {
    switch (side) {
      case 'client':
        return clientColor;
      case 'server':
        return serverColor;
      case 'both':
        return bothColor;
      default:
        return unknownColor;
    }
  }
}
