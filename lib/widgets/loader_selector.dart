import 'package:flutter/material.dart';
import '../models/mod_info.dart';
import '../theme/minecraft_theme.dart';

/// Sélecteur de modloader avec des tuiles style Minecraft.
/// Utilise des logos PNG dans assets/images/.
class LoaderSelector extends StatelessWidget {
  final ModLoader selected;
  final ValueChanged<ModLoader> onChanged;
  final String label;

  const LoaderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'MODLOADER',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: MinecraftTheme.gold,
                letterSpacing: 3,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _LoaderTile(
              label: 'Forge',
              imagePath: 'assets/images/forge.png',
              fallbackIcon: Icons.hardware,
              selected: selected == ModLoader.forge,
              onTap: () => onChanged(ModLoader.forge),
            ),
            _LoaderTile(
              label: 'NeoForge',
              imagePath: 'assets/images/neoforge.png',
              fallbackIcon: Icons.auto_awesome,
              selected: selected == ModLoader.neoforge,
              onTap: () => onChanged(ModLoader.neoforge),
            ),
            _LoaderTile(
              label: 'Fabric',
              imagePath: 'assets/images/fabric.png',
              fallbackIcon: Icons.texture,
              selected: selected == ModLoader.fabric,
              onTap: () => onChanged(ModLoader.fabric),
            ),
            _LoaderTile(
              label: 'Quilt',
              imagePath: 'assets/images/quilt.png',
              fallbackIcon: Icons.grid_view_rounded,
              selected: selected == ModLoader.quilt,
              onTap: () => onChanged(ModLoader.quilt),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoaderTile extends StatefulWidget {
  final String label;
  final String imagePath;
  final IconData fallbackIcon;
  final bool selected;
  final VoidCallback onTap;

  const _LoaderTile({
    required this.label,
    required this.imagePath,
    required this.fallbackIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_LoaderTile> createState() => _LoaderTileState();
}

class _LoaderTileState extends State<_LoaderTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.selected
        ? MinecraftTheme.emerald
        : _hovered
            ? MinecraftTheme.stone
            : MinecraftTheme.stoneDark;

    final bgColor = widget.selected
        ? MinecraftTheme.emerald.withOpacity(0.15)
        : _hovered
            ? MinecraftTheme.deepslate.withOpacity(0.8)
            : MinecraftTheme.deepslate;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: MinecraftTheme.emerald.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Image.asset(
                  widget.imagePath,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      widget.fallbackIcon,
                      color: widget.selected
                          ? MinecraftTheme.emerald
                          : MinecraftTheme.textSecondary,
                      size: 32,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.selected
                      ? MinecraftTheme.emerald
                      : MinecraftTheme.textPrimary,
                  fontWeight:
                      widget.selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
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
