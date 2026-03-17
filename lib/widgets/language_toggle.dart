import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/translations.dart';
import '../theme/minecraft_theme.dart';

/// Bouton toggle FR/EN affiché en haut à droite.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isFr = langProvider.language == AppLanguage.fr;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => langProvider.toggle(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: MinecraftTheme.deepslate,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: MinecraftTheme.stoneDark, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isFr ? '🇫🇷' : '🇬🇧',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                isFr ? 'FR' : 'EN',
                style: const TextStyle(
                  color: MinecraftTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
