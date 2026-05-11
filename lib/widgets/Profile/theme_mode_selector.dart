import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskez/Theme/app_palette.dart';
import 'package:taskez/Theme/theme_controller.dart';
import 'package:taskez/l10n/app_localizations.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_6, color: palette.iconPrimary),
              const SizedBox(width: 12),
              Text(
                l.settingsAppearance,
                style: GoogleFonts.lato(
                  color: palette.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.mode,
            builder: (context, mode, _) {
              return Row(
                children: [
                  _ModeChip(
                    label: l.settingsThemeSystem,
                    icon: Icons.brightness_auto,
                    selected: mode == ThemeMode.system,
                    onTap: () =>
                        ThemeController.instance.setMode(ThemeMode.system),
                  ),
                  const SizedBox(width: 8),
                  _ModeChip(
                    label: l.settingsThemeLight,
                    icon: Icons.wb_sunny_outlined,
                    selected: mode == ThemeMode.light,
                    onTap: () =>
                        ThemeController.instance.setMode(ThemeMode.light),
                  ),
                  const SizedBox(width: 8),
                  _ModeChip(
                    label: l.settingsThemeDark,
                    icon: Icons.nightlight_round,
                    selected: mode == ThemeMode.dark,
                    onTap: () =>
                        ThemeController.instance.setMode(ThemeMode.dark),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bg = selected ? palette.accent : palette.surfaceElevated;
    final fg = selected ? palette.textInverse : palette.textPrimary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: GoogleFonts.lato(
                      color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
