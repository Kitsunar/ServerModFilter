import 'package:flutter/material.dart';

/// Langues supportées.
enum AppLanguage { fr, en }

/// Classe de traduction avec toutes les chaînes de l'app.
class AppTranslations {
  // ── Accueil ──
  final String appTitle;
  final String appSubtitle;
  final String modloaderLabel;
  final String importLabel;
  final String importDescription;
  final String btnSelectFolder;
  final String btnImportZip;
  final String infoText;
  final String dialogSelectFolder;
  final String dialogSelectZip;

  // ── Analyse ──
  final String analyzingTitle;
  final String analyzingPercent; // utiliser avec .replaceAll('{n}', ...)

  // ── Résultats ──
  final String resultsTitle;
  final String tabAll;
  final String tabClient;
  final String tabServer;
  final String tabBoth;
  final String statTotal;
  final String statClient;
  final String statServer;
  final String statBoth;
  final String statUnknown;
  final String emptyCategory;
  final String btnRestart;
  final String btnCreateFolder;
  final String btnExportZip;
  final String confidenceHigh;
  final String confidenceMedium;
  final String confidenceLow;
  final String manualCorrection;
  final String detectionReasons;
  final String sideClient;
  final String sideServer;
  final String sideBoth;
  final String sideUnknown;

  // ── Export ──
  final String exportDoneTitle;
  final String exportDoneMessage;
  final String btnOpenFolder;
  final String btnNewAnalysis;
  final String dialogExportFolder;
  final String dialogExportZip;

  // ── Erreur ──
  final String errorTitle;
  final String btnBackHome;

  // ── Paramètres ──
  final String languageLabel;

  const AppTranslations({
    required this.appTitle,
    required this.appSubtitle,
    required this.modloaderLabel,
    required this.importLabel,
    required this.importDescription,
    required this.btnSelectFolder,
    required this.btnImportZip,
    required this.infoText,
    required this.dialogSelectFolder,
    required this.dialogSelectZip,
    required this.analyzingTitle,
    required this.analyzingPercent,
    required this.resultsTitle,
    required this.tabAll,
    required this.tabClient,
    required this.tabServer,
    required this.tabBoth,
    required this.statTotal,
    required this.statClient,
    required this.statServer,
    required this.statBoth,
    required this.statUnknown,
    required this.emptyCategory,
    required this.btnRestart,
    required this.btnCreateFolder,
    required this.btnExportZip,
    required this.confidenceHigh,
    required this.confidenceMedium,
    required this.confidenceLow,
    required this.manualCorrection,
    required this.detectionReasons,
    required this.sideClient,
    required this.sideServer,
    required this.sideBoth,
    required this.sideUnknown,
    required this.exportDoneTitle,
    required this.exportDoneMessage,
    required this.btnOpenFolder,
    required this.btnNewAnalysis,
    required this.dialogExportFolder,
    required this.dialogExportZip,
    required this.errorTitle,
    required this.btnBackHome,
    required this.languageLabel,
  });

  /// Traductions françaises.
  static const fr = AppTranslations(
    appTitle: 'ServerModFilter',
    appSubtitle: 'Analyse tes mods et crée ton dossier serveur en un clic',
    modloaderLabel: 'MODLOADER',
    importLabel: 'IMPORTER LES MODS',
    importDescription: 'Sélectionne ton dossier "mods" ou un fichier .zip contenant tes mods.',
    btnSelectFolder: 'Sélectionner un dossier mods',
    btnImportZip: 'Importer un fichier .zip',
    infoText: 'L\'app analyse les fichiers .jar pour déterminer si chaque mod est client, serveur ou les deux.',
    dialogSelectFolder: 'Sélectionne ton dossier mods',
    dialogSelectZip: 'Sélectionne un fichier .zip de mods',
    analyzingTitle: 'Analyse en cours...',
    analyzingPercent: '{n}%',
    resultsTitle: 'Analyse terminée',
    tabAll: 'Tous',
    tabClient: 'Client',
    tabServer: 'Serveur',
    tabBoth: 'Les deux',
    statTotal: 'Total',
    statClient: 'Client',
    statServer: 'Serveur',
    statBoth: 'Les deux',
    statUnknown: 'Inconnu',
    emptyCategory: 'Aucun mod dans cette catégorie',
    btnRestart: 'Recommencer',
    btnCreateFolder: 'Créer dossier serveur',
    btnExportZip: 'Exporter en .zip',
    confidenceHigh: 'Fiable',
    confidenceMedium: 'Probable',
    confidenceLow: 'Incertain',
    manualCorrection: 'Corriger manuellement :',
    detectionReasons: 'Raisons de la détection :',
    sideClient: 'Client uniquement',
    sideServer: 'Serveur uniquement',
    sideBoth: 'Client & Serveur',
    sideUnknown: 'Inconnu',
    exportDoneTitle: 'Export terminé !',
    exportDoneMessage: 'Les mods serveur ont été exportés avec succès.',
    btnOpenFolder: 'Ouvrir le dossier',
    btnNewAnalysis: 'Nouvelle analyse',
    dialogExportFolder: 'Choisis le dossier de destination',
    dialogExportZip: 'Enregistrer le .zip des mods serveur',
    errorTitle: 'Oups, une erreur !',
    btnBackHome: 'Retour à l\'accueil',
    languageLabel: 'Langue',
  );

  /// Traductions anglaises.
  static const en = AppTranslations(
    appTitle: 'ServerModFilter',
    appSubtitle: 'Analyze your mods and create your server folder in one click',
    modloaderLabel: 'MODLOADER',
    importLabel: 'IMPORT MODS',
    importDescription: 'Select your "mods" folder or a .zip file containing your mods.',
    btnSelectFolder: 'Select a mods folder',
    btnImportZip: 'Import a .zip file',
    infoText: 'The app analyzes .jar files to determine if each mod is client-side, server-side, or both.',
    dialogSelectFolder: 'Select your mods folder',
    dialogSelectZip: 'Select a .zip file of mods',
    analyzingTitle: 'Analyzing...',
    analyzingPercent: '{n}%',
    resultsTitle: 'Analysis complete',
    tabAll: 'All',
    tabClient: 'Client',
    tabServer: 'Server',
    tabBoth: 'Both',
    statTotal: 'Total',
    statClient: 'Client',
    statServer: 'Server',
    statBoth: 'Both',
    statUnknown: 'Unknown',
    emptyCategory: 'No mods in this category',
    btnRestart: 'Start over',
    btnCreateFolder: 'Create server folder',
    btnExportZip: 'Export as .zip',
    confidenceHigh: 'Reliable',
    confidenceMedium: 'Likely',
    confidenceLow: 'Uncertain',
    manualCorrection: 'Manual correction:',
    detectionReasons: 'Detection reasons:',
    sideClient: 'Client only',
    sideServer: 'Server only',
    sideBoth: 'Client & Server',
    sideUnknown: 'Unknown',
    exportDoneTitle: 'Export complete!',
    exportDoneMessage: 'Server mods have been exported successfully.',
    btnOpenFolder: 'Open folder',
    btnNewAnalysis: 'New analysis',
    dialogExportFolder: 'Choose destination folder',
    dialogExportZip: 'Save server mods .zip',
    errorTitle: 'Oops, an error!',
    btnBackHome: 'Back to home',
    languageLabel: 'Language',
  );

  /// Récupère les traductions selon la langue.
  static AppTranslations of(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.fr:
        return fr;
      case AppLanguage.en:
        return en;
    }
  }
}

/// Provider pour la langue, à intégrer dans le AppProvider.
class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.fr;

  AppLanguage get language => _language;
  AppTranslations get t => AppTranslations.of(_language);

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void toggle() {
    _language = _language == AppLanguage.fr ? AppLanguage.en : AppLanguage.fr;
    notifyListeners();
  }
}
