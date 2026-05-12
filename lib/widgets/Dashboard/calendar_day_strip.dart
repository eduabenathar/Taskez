import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

class CalendarDayStrip extends StatefulWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarDayStrip({
    Key? key,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  // Epoch must be a Sunday.  Jan 2 2000 = Sunday.
  static final _epoch = DateTime(2000, 1, 2);
  static const _pageOffset = 5000;

  @override
  State<CalendarDayStrip> createState() => _CalendarDayStripState();

  static int pageFor(DateTime day) {
    final weekStart = day.subtract(Duration(days: day.weekday % 7));
    final weeks = weekStart.difference(_epoch).inDays ~/ 7;
    return weeks + _pageOffset;
  }

  static DateTime weekStartForPage(int page) {
    final weekOffset = page - _pageOffset;
    return _epoch.add(Duration(days: weekOffset * 7));
  }
}

class _CalendarDayStripState extends State<CalendarDayStrip> {
  late final PageController _controller;

  /// Last page confirmed by onPageChanged (user swipe) or by us (external).
  /// Default 0 so it's never uninitialized even after a hot-reload that
  /// preserves the State but doesn't re-run initState.
  int _currentPage = 0;

  /// Set while we are programmatically animating to an external page so that
  /// the onPageChanged callback ignores intermediate page events.
  bool _externalAnimating = false;

  @override
  void initState() {
    super.initState();
    _currentPage = CalendarDayStrip.pageFor(widget.selectedDay);
    _controller = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(CalendarDayStrip old) {
    super.didUpdateWidget(old);
    if (!_controller.hasClients) return;
    final target = CalendarDayStrip.pageFor(widget.selectedDay);
    // Compare against _currentPage (integer, always up-to-date) not the
    // fractional _controller.page which may still be mid-snap.
    if (_currentPage != target) {
      _currentPage = target;
      _externalAnimating = true;
      _controller
          .animateToPage(
            target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
        if (mounted) setState(() => _externalAnimating = false);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: PageView.builder(
        controller: _controller,
        onPageChanged: (page) {
          _currentPage = page; // always track, even during external animation
          if (_externalAnimating) return;

          final weekStart = CalendarDayStrip.weekStartForPage(page);
          // Keep same day-of-week position within the new week.
          final dow = widget.selectedDay.weekday % 7;
          final newDay =
              DateUtils.dateOnly(weekStart.add(Duration(days: dow)));
          widget.onDaySelected(newDay);
        },
        itemBuilder: (context, page) {
          final weekStart = CalendarDayStrip.weekStartForPage(page);
          final days = List.generate(
            7,
            (i) => DateUtils.dateOnly(weekStart.add(Duration(days: i))),
          );
          return _WeekRow(
            days: days,
            selectedDay: widget.selectedDay,
            onDaySelected: widget.onDaySelected,
          );
        },
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const _WeekRow({
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final weekdayLabels =
        MaterialLocalizations.of(context).narrowWeekdays;

    return Row(
      children: days.map((day) {
        final isSelected = DateUtils.isSameDay(day, selectedDay);
        final isToday = DateUtils.isSameDay(day, DateTime.now());
        return Expanded(
          child: InkWell(
            onTap: () => onDaySelected(day),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.accent.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isToday && !isSelected
                    ? Border.all(
                        color: palette.accent.withValues(alpha: 0.5),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    weekdayLabels[day.weekday % 7],
                    style: GoogleFonts.lato(
                      color: palette.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day.day.toString(),
                    style: GoogleFonts.lato(
                      color: isSelected
                          ? palette.accent
                          : palette.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
