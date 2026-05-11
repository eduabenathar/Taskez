import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.accent,
    required this.accentMuted,
    required this.divider,
    required this.iconPrimary,
    required this.iconMuted,
    required this.shadow,
    required this.overlay,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color accent;
  final Color accentMuted;
  final Color divider;
  final Color iconPrimary;
  final Color iconMuted;
  final Color shadow;
  final Color overlay;
  final Color success;
  final Color warning;
  final Color danger;

  static const AppPalette dark = AppPalette(
    background: Color(0xFF262A34),
    surface: Color(0xFF2F333D),
    surfaceElevated: Color(0xFF393D49),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xB3FFFFFF),
    textMuted: Color(0x80FFFFFF),
    textInverse: Color(0xFF1A1C22),
    accent: Color(0xFF246CFD),
    accentMuted: Color(0xFF3D7BFD),
    divider: Color(0x1FFFFFFF),
    iconPrimary: Color(0xFFFFFFFF),
    iconMuted: Color(0xB3FFFFFF),
    shadow: Color(0x66000000),
    overlay: Color(0x99000000),
    success: Color(0xFF6FCF97),
    warning: Color(0xFFF2C94C),
    danger: Color(0xFFEB5757),
  );

  static const AppPalette light = AppPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1C22),
    textSecondary: Color(0xB31A1C22),
    textMuted: Color(0x801A1C22),
    textInverse: Color(0xFFFFFFFF),
    accent: Color(0xFF246CFD),
    accentMuted: Color(0xFF5A8BFE),
    divider: Color(0x1F000000),
    iconPrimary: Color(0xFF1A1C22),
    iconMuted: Color(0x991A1C22),
    shadow: Color(0x1F000000),
    overlay: Color(0x66000000),
    success: Color(0xFF27AE60),
    warning: Color(0xFFE2A93B),
    danger: Color(0xFFEB5757),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textInverse,
    Color? accent,
    Color? accentMuted,
    Color? divider,
    Color? iconPrimary,
    Color? iconMuted,
    Color? shadow,
    Color? overlay,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textInverse: textInverse ?? this.textInverse,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      divider: divider ?? this.divider,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconMuted: iconMuted ?? this.iconMuted,
      shadow: shadow ?? this.shadow,
      overlay: overlay ?? this.overlay,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
