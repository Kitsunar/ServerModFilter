import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_provider.dart';
import '../models/mod_info.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/minecraft_button.dart';
import '../widgets/mod_card.dart';

/// Écran affichant les résultats de l'analyse.
class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final result = provider.analysisResult;

    if (result == null) return const SizedBox.shrink();

    return Column(
      children: [
        // ── Header avec résumé ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: MinecraftTheme.obsidian,
          child: Column(
            children: [
              Text(
                'Analyse terminée',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: MinecraftTheme.emerald,
                    ),
              ),
              const SizedBox(height: 12),

              // Stats rapides
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatBadge(
                    label: 'Total',
                    count: result.totalCount,
                    color: MinecraftTheme.textPrimary,
                  ),
                  _StatBadge(
                    label: 'Client',
                    count: result.clientOnly.length,
                    color: MinecraftTheme.clientColor,
                  ),
                  _StatBadge(
                    label: 'Serveur',
                    count: result.serverOnly.length,
                    color: MinecraftTheme.serverColor,
                  ),
                  _StatBadge(
                    label: 'Les deux',
                    count: result.bothSides.length,
                    color: MinecraftTheme.bothColor,
                  ),
                  _StatBadge(
                    label: 'Inconnu',
                    count: result.unknown.length,
                    color: MinecraftTheme.unknownColor,
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Onglets ──
        Container(
          color: MinecraftTheme.obsidian,
          child: TabBar(
            controller: _tabController,
            indicatorColor: MinecraftTheme.emerald,
            indicatorWeight: 3,
            labelColor: MinecraftTheme.emerald,
            unselectedLabelColor: MinecraftTheme.textMuted,
            tabs: [
              Tab(text: 'Tous (${result.totalCount})'),
              Tab(text: 'Client (${result.clientOnly.length})'),
              Tab(text: 'Serveur (${result.serverOnly.length})'),
              Tab(text: 'Les deux (${result.bothSides.length})'),
            ],
          ),
        ),

        // ── Liste des mods ──
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ModList(mods: result.mods, provider: provider),
              _ModList(mods: result.clientOnly, provider: provider),
              _ModList(mods: result.serverOnly, provider: provider),
              _ModList(mods: result.bothSides, provider: provider),
            ],
          ),
        ),

        // ── Barre d'actions en bas ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: MinecraftTheme.obsidian,
            border: Border(
              top: BorderSide(color: MinecraftTheme.stoneDark, width: 2),
            ),
          ),
          child: Row(
            children: [
              // Bouton retour
              Expanded(
                child: MinecraftButton(
                  label: 'Recommencer',
                  icon: Icons.arrow_back,
                  color: MinecraftTheme.stoneDark,
                  onPressed: () => provider.reset(),
                ),
              ),
              const SizedBox(width: 16),

              // Bouton export zip
              Expanded(
                flex: 2,
                child: MinecraftButton(
                  label: 'Exporter en .zip',
                  icon: Icons.archive,
                  color: MinecraftTheme.lapis,
                  onPressed: () => _exportZip(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _exportFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choisis le dossier de destination',
    );
    if (result != null && context.mounted) {
      context.read<AppProvider>().exportToFolder(result);
    }
  }

  Future<void> _exportZip(BuildContext context) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Enregistrer le .zip des mods serveur',
      fileName: 'server_mods.zip',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null && context.mounted) {
      context.read<AppProvider>().exportToZip(result);
    }
  }
}

/// Liste scrollable de mods.
class _ModList extends StatelessWidget {
  final List<ModInfo> mods;
  final AppProvider provider;

  const _ModList({required this.mods, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (mods.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                color: MinecraftTheme.textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              'Aucun mod dans cette catégorie',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mods.length,
      itemBuilder: (context, index) {
        final mod = mods[index];
        // Trouver l'index réel dans la liste complète
        final realIndex = provider.analysisResult!.mods.indexOf(mod);

        return ModCard(
          mod: mod,
          index: index,
          onSideChanged: (newSide) {
            if (realIndex >= 0) {
              provider.overrideModSide(realIndex, newSide);
            }
          },
        );
      },
    );
  }
}

/// Badge de statistique.
class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
