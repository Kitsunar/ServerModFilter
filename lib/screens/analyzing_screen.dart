import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/minecraft_theme.dart';

/// Écran affiché pendant l'analyse des mods.
class AnalyzingScreen extends StatelessWidget {
  const AnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final percent = (provider.progress * 100).toInt();

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
                // Icône animée
                const _PixelLoadingIndicator(),
                const SizedBox(height: 24),

                Text(
                  'Analyse en cours...',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: MinecraftTheme.emerald,
                      ),
                ),
                const SizedBox(height: 8),

                Text(
                  provider.currentModName,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),

                // Barre de progression style Minecraft
                _MinecraftProgressBar(progress: provider.progress),
                const SizedBox(height: 12),

                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MinecraftTheme.emerald,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barre de progression pixelisée.
class _MinecraftProgressBar extends StatelessWidget {
  final double progress;

  const _MinecraftProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MinecraftTheme.bedrock,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: MinecraftTheme.stoneDark, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final filledWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: filledWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: MinecraftTheme.emerald,
                  borderRadius: BorderRadius.circular(1),
                  // Effet "blocs" pixelisés
                  gradient: LinearGradient(
                    colors: [
                      MinecraftTheme.emerald,
                      MinecraftTheme.emerald.withOpacity(0.85),
                      MinecraftTheme.emerald,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Indicateur de chargement pixelisé animé.
class _PixelLoadingIndicator extends StatefulWidget {
  const _PixelLoadingIndicator();

  @override
  State<_PixelLoadingIndicator> createState() => _PixelLoadingIndicatorState();
}

class _PixelLoadingIndicatorState extends State<_PixelLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: _PixelSpinnerPainter(
              progress: _controller.value,
              color: MinecraftTheme.emerald,
            ),
          ),
        );
      },
    );
  }
}

class _PixelSpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PixelSpinnerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint();

    // 8 blocs qui tournent autour du centre
    final positions = [
      const Offset(3, 0), const Offset(4, 0),
      const Offset(5, 1), const Offset(6, 3),
      const Offset(5, 5), const Offset(4, 6),
      const Offset(2, 5), const Offset(1, 3),
    ];

    for (int i = 0; i < positions.length; i++) {
      final delay = i / positions.length;
      final opacity = ((progress + delay) % 1.0);
      paint.color = color.withOpacity(opacity.clamp(0.2, 1.0));

      canvas.drawRect(
        Rect.fromLTWH(
          positions[i].dx * pixelSize,
          positions[i].dy * pixelSize,
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelSpinnerPainter old) => old.progress != progress;
}
