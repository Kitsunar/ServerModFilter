import 'package:flutter/material.dart';
import '../models/mod_info.dart';
import '../theme/minecraft_theme.dart';

/// Carte affichant les infos d'un mod dans les résultats.
class ModCard extends StatefulWidget {
  final ModInfo mod;
  final int index;
  final ValueChanged<ModSide>? onSideChanged;

  const ModCard({
    super.key,
    required this.mod,
    required this.index,
    this.onSideChanged,
  });

  @override
  State<ModCard> createState() => _ModCardState();
}

class _ModCardState extends State<ModCard> {
  bool _expanded = false;

  Color get _sideColor {
    switch (widget.mod.side) {
      case ModSide.client:
        return MinecraftTheme.clientColor;
      case ModSide.server:
        return MinecraftTheme.serverColor;
      case ModSide.both:
        return MinecraftTheme.bothColor;
      case ModSide.unknown:
        return MinecraftTheme.unknownColor;
    }
  }

  IconData get _sideIcon {
    switch (widget.mod.side) {
      case ModSide.client:
        return Icons.monitor;
      case ModSide.server:
        return Icons.dns;
      case ModSide.both:
        return Icons.sync_alt;
      case ModSide.unknown:
        return Icons.help_outline;
    }
  }

  String get _confidenceLabel {
    switch (widget.mod.confidence) {
      case DetectionConfidence.high:
        return 'Fiable';
      case DetectionConfidence.medium:
        return 'Probable';
      case DetectionConfidence.low:
        return 'Incertain';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: MinecraftTheme.deepslate,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _sideColor.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Indicateur de couleur
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _sideColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Icône side
                  Icon(_sideIcon, color: _sideColor, size: 24),
                  const SizedBox(width: 12),

                  // Nom et infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mod.displayName,
                          style: const TextStyle(
                            color: MinecraftTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.mod.sideLabel} • ${widget.mod.formattedSize}',
                          style: TextStyle(
                            color: _sideColor.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge de confiance
                  _ConfidenceBadge(
                    label: _confidenceLabel,
                    confidence: widget.mod.confidence,
                  ),

                  const SizedBox(width: 8),

                  // Chevron
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: MinecraftTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),

          // Détails expandables
          if (_expanded) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: MinecraftTheme.stoneDark),
                  const SizedBox(height: 8),

                  // Infos détaillées
                  if (widget.mod.modId != null)
                    _DetailRow(label: 'Mod ID', value: widget.mod.modId!),
                  if (widget.mod.version != null)
                    _DetailRow(label: 'Version', value: widget.mod.version!),
                  _DetailRow(label: 'Fichier', value: widget.mod.fileName),

                  if (widget.mod.detectionReasons.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Raisons de la détection :',
                      style: TextStyle(
                        color: MinecraftTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...widget.mod.detectionReasons.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                        child: Text(
                          '• $r',
                          style: const TextStyle(
                            color: MinecraftTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Boutons de correction manuelle
                  if (widget.onSideChanged != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Corriger manuellement :',
                      style: TextStyle(
                        color: MinecraftTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ModSide.values.map((side) {
                        final isActive = widget.mod.side == side;
                        return _SideChip(
                          label: _sideName(side),
                          color: _sideColorFor(side),
                          active: isActive,
                          onTap: isActive
                              ? null
                              : () => widget.onSideChanged?.call(side),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _sideName(ModSide side) {
    switch (side) {
      case ModSide.client:
        return 'Client';
      case ModSide.server:
        return 'Serveur';
      case ModSide.both:
        return 'Les deux';
      case ModSide.unknown:
        return 'Inconnu';
    }
  }

  Color _sideColorFor(ModSide side) {
    switch (side) {
      case ModSide.client:
        return MinecraftTheme.clientColor;
      case ModSide.server:
        return MinecraftTheme.serverColor;
      case ModSide.both:
        return MinecraftTheme.bothColor;
      case ModSide.unknown:
        return MinecraftTheme.unknownColor;
    }
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final String label;
  final DetectionConfidence confidence;

  const _ConfidenceBadge({required this.label, required this.confidence});

  Color get _color {
    switch (confidence) {
      case DetectionConfidence.high:
        return MinecraftTheme.emerald;
      case DetectionConfidence.medium:
        return MinecraftTheme.gold;
      case DetectionConfidence.low:
        return MinecraftTheme.redstone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: _color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: MinecraftTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: MinecraftTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;
  final VoidCallback? onTap;

  const _SideChip({
    required this.label,
    required this.color,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: active ? color : MinecraftTheme.stoneDark,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? color : MinecraftTheme.textMuted,
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
