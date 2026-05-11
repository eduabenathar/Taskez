import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskez/Controllers/locale_controller.dart';
import 'package:taskez/Theme/app_palette.dart';
import 'package:taskez/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

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
              Icon(Icons.language, color: palette.iconPrimary),
              const SizedBox(width: 12),
              Text(
                l.commonLanguage,
                style: GoogleFonts.lato(
                  color: palette.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<Locale?>(
            valueListenable: LocaleController.instance.locale,
            builder: (context, locale, _) {
              return Row(
                children: [
                  _LocaleChip(
                    label: l.commonSystemDefault,
                    selected: locale == null,
                    onTap: () =>
                        LocaleController.instance.setLocale(null),
                  ),
                  const SizedBox(width: 8),
                  _LocaleChip(
                    label: l.commonEnglish,
                    selected: locale?.languageCode == 'en',
                    onTap: () =>
                        LocaleController.instance.setLocale(LocaleController.en),
                  ),
                  const SizedBox(width: 8),
                  _LocaleChip(
                    label: l.commonPortugueseBR,
                    selected: locale?.languageCode == 'pt',
                    onTap: () =>
                        LocaleController.instance.setLocale(LocaleController.ptBR),
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

class _LocaleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LocaleChip({
    required this.label,
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
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: fg, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
