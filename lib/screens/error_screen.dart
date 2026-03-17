import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/minecraft_button.dart';

/// Écran d'erreur.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MinecraftTheme.redstone.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MinecraftTheme.redstone.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: MinecraftTheme.redstone,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Oups, une erreur !',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: MinecraftTheme.redstone,
                      ),
                ),
                const SizedBox(height: 12),

                if (provider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MinecraftTheme.bedrock,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: MinecraftTheme.redstone.withOpacity(0.3)),
                    ),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(
                        color: MinecraftTheme.redstone,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                MinecraftButton(
                  label: 'Retour à l\'accueil',
                  icon: Icons.home,
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
