import 'package:flutter/material.dart';

/// Shared color tokens for the dashboard project/task cards. Adapts to the
/// current [Brightness] so widgets only need to pick a token by name.
class DashboardCardPalette {
  DashboardCardPalette._({
    required this.cardBackground,
    required this.cardBorder,
    required this.titleText,
    required this.bodyText,
    required this.progressTrack,
    required this.accent,
    required this.accentSoft,
    required this.danger,
    required this.dangerSoft,
    required this.amber,
    required this.amberSoft,
    required this.cardShadow,
    required this.primaryIcon,
  });

  final Color cardBackground;
  final Color cardBorder;
  final Color titleText;
  final Color bodyText;
  final Color progressTrack;
  final Color accent;
  final Color accentSoft;
  final Color danger;
  final Color dangerSoft;
  final Color amber;
  final Color amberSoft;
  final Color cardShadow;
  final Color primaryIcon;

  factory DashboardCardPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? DashboardCardPalette._(
            cardBackground: const Color(0xFF3A3F4D),
            cardBorder: const Color(0x14FFFFFF),
            titleText: Colors.white,
            bodyText: const Color(0xFFB1B5BF),
            progressTrack: const Color(0xFF4A4F5E),
            accent: const Color(0xFFA6A4F5),
            accentSoft: const Color(0xFF302F66),
            danger: const Color(0xFFF0A1A1),
            dangerSoft: const Color(0xFF4A2222),
            amber: const Color(0xFFE8C684),
            amberSoft: const Color(0xFF49381B),
            cardShadow: const Color(0x66000000),
            primaryIcon: Colors.white,
          )
        : DashboardCardPalette._(
            cardBackground: Colors.white,
            cardBorder: const Color(0xFFE5E6EB),
            titleText: const Color(0xFF1A1C22),
            bodyText: const Color(0xFF6B6F7A),
            progressTrack: const Color(0xFFEDEEF1),
            accent: const Color(0xFF5B5BF0),
            accentSoft: const Color(0xFFE9E7FD),
            danger: const Color(0xFFD14B4B),
            dangerSoft: const Color(0xFFFBE0E0),
            amber: const Color(0xFFD4923F),
            amberSoft: const Color(0xFFFBE9D3),
            cardShadow: const Color(0x12000000),
            primaryIcon: const Color(0xFF1A1C22),
          );
  }
}
