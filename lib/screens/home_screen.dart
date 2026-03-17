import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_provider.dart';
import '../models/mod_info.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/minecraft_button.dart';
import '../widgets/loader_selector.dart';

/// Écran d'accueil : choix du modloader + import des mods.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo / Titre ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: MinecraftTheme.minecraftBox,
                child: Column(
                  children: [
                    // Icône stylisée
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MinecraftTheme.obsidian,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: MinecraftTheme.emerald.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ServerModFilter',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: MinecraftTheme.emerald,
                                shadows: [
                                  const Shadow(
                                    color: Color(0x60000000),
                                    offset: Offset(3, 3),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analyse tes mods et crée ton dossier serveur en un clic',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: MinecraftTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Sélection du Modloader ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: MinecraftTheme.minecraftBox,
                child: LoaderSelector(
                  selected: provider.selectedLoader,
                  onChanged: (loader) => provider.setLoader(loader),
                ),
              ),

              const SizedBox(height: 32),

              // ── Boutons d'import ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: MinecraftTheme.minecraftBox,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IMPORTER LES MODS',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: MinecraftTheme.gold,
                                letterSpacing: 3,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sélectionne ton dossier "mods" ou un fichier .zip contenant tes mods.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 12),

                    // Bouton zip
                    MinecraftButton(
                      label: 'Importer un fichier .zip',
                      icon: Icons.archive_outlined,
                      color: MinecraftTheme.lapis,
                      onPressed: () => _pickZip(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Info ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MinecraftTheme.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: MinecraftTheme.gold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: MinecraftTheme.gold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'L\'app analyse les fichiers .jar pour déterminer si chaque mod est client, serveur ou les deux.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: MinecraftTheme.gold.withOpacity(0.9),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Sélectionne ton dossier mods',
    );

    if (result != null && context.mounted) {
      context.read<AppProvider>().analyzeFromPath(result);
    }
  }

  Future<void> _pickZip(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      dialogTitle: 'Sélectionne un fichier .zip de mods',
    );

    if (result != null && result.files.single.path != null && context.mounted) {
      context.read<AppProvider>().analyzeFromPath(result.files.single.path!);
    }
  }
}
