# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get               # Install dependencies
flutter run                   # Run on connected device/emulator
flutter run -d chrome         # Run on web
flutter analyze               # Run Dart static analysis
dart format lib/              # Format Dart code
flutter test                  # Run tests (minimal coverage — one placeholder test)
flutter build apk             # Android release build
flutter build ios             # iOS release build
flutter pub run flutter_launcher_icons:main  # Regenerate app icons
```

## Architecture

Taskez is a Flutter UI kit / design showcase for a task management app. It has no backend, no persistence, no API calls — all data is hardcoded in `lib/Data/data_model.dart`.

### Directory layout

```
lib/
├── main.dart              # App entry, GetMaterialApp setup
├── Screens/               # Feature screens organized by domain (Auth, Dashboard, Chat, Projects, Profile, Task, Onboarding)
├── widgets/               # Reusable components, organized by feature subdirectory
├── Data/                  # Static mock data (AppData class with hardcoded lists)
├── Constants/             # Dashboard config, gradient lists, online users
├── Values/                # Design system: colors, text styles, button styles, spacing, box decorations
├── Utils/                 # Utility class, SineCurve animation, image builders
└── BottomSheets/          # Bottom sheet exports
```

### State management

- **`ValueNotifier<T>` + `ValueListenableBuilder`** — the exclusive pattern for reactive UI state (toggle switches, tab selections, etc.)
- State is always local to the widget; there is no app-wide state layer
- `provider` is listed in `pubspec.yaml` but is **not used** anywhere

### Navigation

`get` package (v4.6.5) is used only for routing — `Get.to()` and `Get.off()`. It is not used for dependency injection or controllers.

### Design system (`lib/Values/`)

All screens consume from this centralized layer:
- `app-colors.dart` — `HexColor.fromHex()` extension, color palettes
- `styles.dart` — `AppTextStyles` via Google Fonts (Lato)
- `spacing.dart` — `AppSpaces` constants
- `button_styles.dart`, `box_decoration_styles.dart` — reusable decoration

### Naming conventions

| Thing | Convention |
|---|---|
| Screen files | `snake_case_screen.dart` |
| Widget files | `snake_case.dart` |
| Classes | `PascalCase` |
| Directories | `PascalCase` (`Screens/`, `Auth/`, `Dashboard/`) |

### Key packages

| Package | Purpose |
|---|---|
| `get` | Navigation only |
| `google_fonts` | Typography (Lato) |
| `responsive_builder` | Responsive layouts |
| `fl_chart` | Charts |
| `table_calendar` | Calendar widget |
| `glassmorphism` | Frosted glass effects |
| `tcard` | Card swipe animations |
| `flutter_slidable` | Swipe-to-action lists |
| `font_awesome_flutter`, `flutter_feather_icons` | Icon sets |
