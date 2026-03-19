# ⛏️ ServerModFilter

**Analyse tes mods Minecraft et crée ton dossier mods serveur en un clic.**

ServerModFilter analyse les fichiers `.jar` de tes mods pour déterminer automatiquement lesquels sont côté client, côté serveur, ou les deux. Plus besoin de vérifier chaque mod manuellement !

---

## ✨ Fonctionnalités

### Mode Rapide — Analyse seule
- Importe un dossier `.zip`
- Analyse automatique de chaque `.jar`
- Affichage par catégorie : **Client**, **Serveur**, **Client & Serveur**, **Inconnu**
- Niveau de confiance pour chaque détection
- Correction manuelle possible si la détection est incorrecte

### Mode Complet — Analyse + Export
- Tout ce que fait le mode rapide
- Crée automatiquement un dossier `server_mods` (sans les mods client-only)
- Export en `.zip`
- Génère un rapport d'analyse détaillé

---

## 🔧 Modloaders supportés

| Loader    | Méthode de détection                     |
|-----------|------------------------------------------|
| Forge     | `META-INF/mods.toml` → champ `side`     |
| NeoForge  | `META-INF/mods.toml` → champ `side`     |
| Fabric    | `fabric.mod.json` → champ `environment` |
| Quilt     | `quilt.mod.json` → `minecraft.environment` |

Quand les métadonnées sont incomplètes, l'app utilise :
1. Une **base de données de mods connus** (OptiFine, JourneyMap, etc.)
2. Une **analyse heuristique des classes** dans le `.jar`

---


### Prérequis

- Windows 10/11

### Étapes

Rendez-vous dans l'onglet Release de GitHub et télécharger le fichier.zip pour Windows.

Une fois télécharger, dézippé le fichier.

Après quoi, il ne vous restera plus qu'a exécuter le .exe dans le fichier.

# Important

Ne surtout pas déplacer le .exe du fichier.

---

## 📁 Architecture du projet

```
server_mod_filter/
├── lib/
│   ├── main.dart                  # Point d'entrée
│   ├── models/
│   │   ├── mod_info.dart          # Modèle d'un mod
│   │   └── analysis_result.dart   # Résultat d'analyse
│   ├── services/
│   │   ├── mod_analyzer_service.dart   # Moteur d'analyse des .jar
│   │   ├── known_mods_database.dart    # Base de mods connus
│   │   └── export_service.dart         # Export dossier/zip
│   ├── providers/
│   │   └── app_provider.dart      # State management (Provider)
│   ├── screens/
│   │   ├── home_screen.dart       # Accueil + sélection loader
│   │   ├── analyzing_screen.dart  # Progression de l'analyse
│   │   ├── results_screen.dart    # Résultats avec onglets
│   │   ├── done_screen.dart       # Confirmation export
│   │   └── error_screen.dart      # Écran d'erreur
│   ├── widgets/
│   │   ├── minecraft_button.dart  # Bouton style MC
│   │   ├── loader_selector.dart   # Sélecteur de modloader
│   │   └── mod_card.dart          # Carte d'un mod
│   └── theme/
│       └── minecraft_theme.dart   # Thème Minecraft complet
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 🎨 Design

L'interface utilise un thème sombre :
- Palette : obsidienne, deepslate, émeraude, diamant, redstone, or
- Couleurs par catégorie : 🔵 Client (diamant) / 🟡 Serveur (or) / 🟢 Les deux (émeraude) / 🔴 Inconnu (redstone)

---

## 📝 Contribuer

Les contributions sont les bienvenues ! En particulier :
- Enrichir la base de données de mods connus (`known_mods_database.dart`)
- Améliorer les heuristiques de détection
- Ajouter le support d'autres modloaders

---

## 📜 Licence

MIT — Utilise, modifie, distribue librement.
