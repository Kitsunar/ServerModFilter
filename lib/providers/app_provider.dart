import 'package:flutter/material.dart';
import '../models/mod_info.dart';
import '../models/analysis_result.dart';
import '../services/mod_analyzer_service.dart';
import '../services/export_service.dart';

/// État possible de l'application.
enum AppState {
  home,        // Écran d'accueil - choix du loader
  selecting,   // Sélection du fichier/dossier
  analyzing,   // Analyse en cours
  results,     // Résultats affichés
  exporting,   // Export en cours
  done,        // Export terminé
  error,       // Erreur
}

/// Provider principal qui gère tout l'état de l'application.
class AppProvider extends ChangeNotifier {
  final ModAnalyzerService _analyzer = ModAnalyzerService();
  final ExportService _exporter = ExportService();

  // ── État ──
  AppState _state = AppState.home;
  AppState get state => _state;

  // ── Loader sélectionné ──
  ModLoader _selectedLoader = ModLoader.forge;
  ModLoader get selectedLoader => _selectedLoader;

  // ── Résultat d'analyse ──
  AnalysisResult? _analysisResult;
  AnalysisResult? get analysisResult => _analysisResult;

  // ── Progression ──
  double _progress = 0.0;
  double get progress => _progress;

  String _currentModName = '';
  String get currentModName => _currentModName;

  // ── Erreur ──
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Chemin d'export ──
  String? _exportPath;
  String? get exportPath => _exportPath;

  // ── Mods avec correction manuelle ──
  final Map<String, ModSide> _manualOverrides = {};

  /// Change le modloader sélectionné.
  void setLoader(ModLoader loader) {
    _selectedLoader = loader;
    notifyListeners();
  }

  /// Lance l'analyse des mods.
  Future<void> analyzeFromPath(String inputPath) async {
    _state = AppState.analyzing;
    _progress = 0.0;
    _currentModName = '';
    _errorMessage = null;
    notifyListeners();

    try {
      _analysisResult = await _analyzer.analyze(
        inputPath: inputPath,
        selectedLoader: _selectedLoader,
        onProgress: (progress, modName) {
          _progress = progress;
          _currentModName = modName;
          notifyListeners();
        },
      );

      _state = AppState.results;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AppState.error;
    }

    notifyListeners();
  }

  /// Corrige manuellement le côté d'un mod.
  void overrideModSide(int index, ModSide newSide) {
    if (_analysisResult == null) return;

    final mods = List<ModInfo>.from(_analysisResult!.mods);
    mods[index] = mods[index].copyWithSide(newSide);

    _analysisResult = AnalysisResult(
      mods: mods,
      selectedLoader: _analysisResult!.selectedLoader,
      analyzedAt: _analysisResult!.analyzedAt,
      sourcePath: _analysisResult!.sourcePath,
    );

    notifyListeners();
  }

  /// Exporte les mods serveur dans un dossier.
  Future<void> exportToFolder(String outputPath) async {
    if (_analysisResult == null) return;

    _state = AppState.exporting;
    _progress = 0.0;
    notifyListeners();

    try {
      _exportPath = await _exporter.exportServerMods(
        analysis: _analysisResult!,
        outputPath: outputPath,
        onProgress: (progress, modName) {
          _progress = progress;
          _currentModName = modName;
          notifyListeners();
        },
      );

      _state = AppState.done;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AppState.error;
    }

    notifyListeners();
  }

  /// Exporte les mods serveur en .zip.
  Future<void> exportToZip(String outputZipPath) async {
    if (_analysisResult == null) return;

    _state = AppState.exporting;
    _progress = 0.0;
    notifyListeners();

    try {
      _exportPath = await _exporter.exportServerModsAsZip(
        analysis: _analysisResult!,
        outputZipPath: outputZipPath,
        onProgress: (progress, modName) {
          _progress = progress;
          _currentModName = modName;
          notifyListeners();
        },
      );

      _state = AppState.done;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AppState.error;
    }

    notifyListeners();
  }

  /// Retour à l'accueil.
  void reset() {
    _state = AppState.home;
    _analysisResult = null;
    _progress = 0.0;
    _currentModName = '';
    _errorMessage = null;
    _exportPath = null;
    _manualOverrides.clear();
    notifyListeners();
  }
}
