import 'package:flutter/material.dart';
import '../theme/minecraft_theme.dart';

/// Bouton avec l'effet 3D style Minecraft.
class MinecraftButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final double width;
  final bool enabled;

  const MinecraftButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = MinecraftTheme.grass,
    this.icon,
    this.width = double.infinity,
    this.enabled = true,
  });

  @override
  State<MinecraftButton> createState() => _MinecraftButtonState();
}

class _MinecraftButtonState extends State<MinecraftButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.enabled ? widget.color : MinecraftTheme.stoneDark;
    final darker = Color.lerp(color, Colors.black, 0.35) ?? color;
    final lighter = Color.lerp(color, Colors.white, 0.25) ?? color;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: 50,
        color: const Color.fromARGB(255, 4, 94, 12),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
