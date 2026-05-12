import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/Values/values.dart';

/// 6-week month grid. Spill-over days from previous/next month are dimmed.
/// Days with events show a small dot beneath the day number.
class CalendarMonthGrid extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const CalendarMonthGrid({
    Key? key,
    required this.visibleMonth,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  }) : super(key: key);

  // Colors derived from palette at build time — see _MonthCell.

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final monthLabel =
        MaterialLocalizations.of(context).formatMonthYear(visibleMonth);
    final weekdayLabels = MaterialLocalizations.of(context).narrowWeekdays;

    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final gridStart =
        firstOfMonth.subtract(Duration(days: firstOfMonth.weekday % 7));
    final today = DateUtils.dateOnly(DateTime.now());

    final eventDays = <DateTime>{
      for (final e in CalendarStore.instance.events.value)
        DateUtils.dateOnly(e.date),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _MonthChevron(
              icon: Icons.chevron_left,
              onTap: onPrevMonth,
              palette: palette,
            ),
            Expanded(
              child: Center(
                child: Text(
                  monthLabel,
                  style: GoogleFonts.lato(
                    color: palette.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            _MonthChevron(
              icon: Icons.chevron_right,
              onTap: onNextMonth,
              palette: palette,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(7, (i) {
            return Expanded(
              child: Center(
                child: Text(
                  weekdayLabels[i],
                  style: GoogleFonts.lato(
                    color: palette.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        for (var week = 0; week < 6; week++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: List.generate(7, (col) {
                final day = DateUtils.dateOnly(
                  gridStart.add(Duration(days: week * 7 + col)),
                );
                final inMonth = day.month == visibleMonth.month;
                final isSelected = DateUtils.isSameDay(day, selectedDay);
                final isToday = DateUtils.isSameDay(day, today);
                final hasEvent = eventDays.contains(day);

                return Expanded(
                  child: _MonthCell(
                    day: day,
                    inMonth: inMonth,
                    isSelected: isSelected,
                    isToday: isToday,
                    hasEvent: hasEvent,
                    palette: palette,
                    onTap: () => onDaySelected(day),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _MonthCell extends StatelessWidget {
  final DateTime day;
  final bool inMonth;
  final bool isSelected;
  final bool isToday;
  final bool hasEvent;
  final AppPalette palette;
  final VoidCallback onTap;

  const _MonthCell({
    required this.day,
    required this.inMonth,
    required this.isSelected,
    required this.isToday,
    required this.hasEvent,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedFg = palette.accent;
    final selectedBg = palette.accent.withValues(alpha: 0.15);
    final textColor = isSelected
        ? selectedFg
        : inMonth
            ? palette.textPrimary
            : palette.textMuted.withValues(alpha: 0.55);

    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: !isSelected && isToday
              ? Border.all(
                  color: palette.accent.withValues(alpha: 0.6),
                  width: 1.2,
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day.day.toString(),
              style: GoogleFonts.lato(
                color: textColor,
                fontSize: 15,
                fontWeight: isSelected || isToday
                    ? FontWeight.w800
                    : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: hasEvent ? 1 : 0,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: palette.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthChevron extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppPalette palette;

  const _MonthChevron({
    required this.icon,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 22, color: palette.iconPrimary),
      ),
    );
  }
}
