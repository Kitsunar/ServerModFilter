import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/app_provider.dart';
import 'theme/minecraft_theme.dart';
import 'screens/home_screen.dart';
import 'screens/analyzing_screen.dart';
import 'screens/results_screen.dart';
import 'screens/done_screen.dart';
import 'screens/error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de la fenêtre Windows
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(960, 720),
    minimumSize: Size(800, 600),
    center: true,
    title: 'ServerModFilter',
    backgroundColor: MinecraftTheme.bedrock,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ServerModFilterApp());
}

class ServerModFilterApp extends StatelessWidget {
  const ServerModFilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'ServerModFilter',
        debugShowCheckedModeBanner: false,
        theme: MinecraftTheme.darkTheme,
        home: const MainShell(),
      ),
    );
  }
}

/// Shell principal qui switch entre les écrans selon l'état.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppProvider>().state;

    return Scaffold(
      backgroundColor: MinecraftTheme.bedrock,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildScreen(state),
      ),
    );
  }

  Widget _buildScreen(AppState state) {
    switch (state) {
      case AppState.home:
      case AppState.selecting:
        return const HomeScreen();
      case AppState.analyzing:
      case AppState.exporting:
        return const AnalyzingScreen();
      case AppState.results:
        return const ResultsScreen();
      case AppState.done:
        return const DoneScreen();
      case AppState.error:
        return const ErrorScreen();
    }
  }
}
