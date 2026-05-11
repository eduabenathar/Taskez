import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

ThemeData buildDarkTheme() => _build(AppPalette.dark, Brightness.dark);
ThemeData buildLightTheme() => _build(AppPalette.light, Brightness.light);

ThemeData _build(AppPalette palette, Brightness brightness) {
  final overlay = brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;

  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: palette.background,
    canvasColor: palette.background,
    primaryColor: palette.accent,
    dividerColor: palette.divider,
    iconTheme: IconThemeData(color: palette.iconPrimary),
    colorScheme: (brightness == Brightness.dark
            ? const ColorScheme.dark()
            : const ColorScheme.light())
        .copyWith(
      primary: palette.accent,
      secondary: palette.accent,
      surface: palette.surface,
      onSurface: palette.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      systemOverlayStyle: overlay,
    ),
    extensions: <ThemeExtension<dynamic>>[palette],
  );
}
