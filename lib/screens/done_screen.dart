import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/minecraft_button.dart';

/// Écran affiché après un export réussi.
class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: MinecraftTheme.minecraftBox,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône succès
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MinecraftTheme.emerald.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MinecraftTheme.emerald.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: MinecraftTheme.emerald,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Export terminé !',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: MinecraftTheme.emerald,
                      ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Les mods serveur ont été exportés avec succès.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                if (provider.exportPath != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MinecraftTheme.bedrock,
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: MinecraftTheme.stoneDark, width: 1),
                    ),
                    child: Text(
                      provider.exportPath!,
                      style: const TextStyle(
                        color: MinecraftTheme.textSecondary,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bouton ouvrir le dossier
                  MinecraftButton(
                    label: 'Ouvrir le dossier',
                    icon: Icons.folder_open,
                    color: MinecraftTheme.lapis,
                    onPressed: () async {
                      final uri = Uri.file(provider.exportPath!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                ],

                const SizedBox(height: 16),

                MinecraftButton(
                  label: 'Nouvelle analyse',
                  icon: Icons.refresh,
                  color: MinecraftTheme.grass,
                  onPressed: () => provider.reset(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
