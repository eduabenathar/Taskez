import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/Dashboard/calendar_event_card.dart';

class CalendarTimeLine extends StatefulWidget {
  final List<CalendarEventData> events;
  final DateTime selectedDay;
  final ValueChanged<CalendarEventData>? onEventTap;

  const CalendarTimeLine({
    Key? key,
    required this.events,
    required this.selectedDay,
    this.onEventTap,
  }) : super(key: key);

  /// Full 24-hour day; row height balances scroll length with card legibility.
  static const double hourHeight = 140;
  static const double _timeColumnWidth = 56;
  static const int _startHour = 0;
  static const int _endHour = 23;

  @override
  State<CalendarTimeLine> createState() => _CalendarTimeLineState();
}

class _CalendarTimeLineState extends State<CalendarTimeLine> {
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _tickTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = widget.events
        .where((e) => DateUtils.isSameDay(e.date, widget.selectedDay))
        .toList();

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final isToday = DateUtils.isSameDay(widget.selectedDay, now);
    final showCurrentTime = isToday;

    final totalHeight =
        (CalendarTimeLine._endHour - CalendarTimeLine._startHour + 1) *
            CalendarTimeLine.hourHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var hour = CalendarTimeLine._startHour;
              hour <= CalendarTimeLine._endHour;
              hour++)
            _HourMarker(
              top: (hour - CalendarTimeLine._startHour) *
                  CalendarTimeLine.hourHeight,
              hourHeight: CalendarTimeLine.hourHeight,
              hourLabel: _formatHour(context, hour),
            ),
          for (final event in dayEvents)
            Positioned(
              top: _minutesToOffset(event.startMinutes),
              left: CalendarTimeLine._timeColumnWidth,
              right: 0,
              height: _eventHeight(event.durationMinutes),
              child: CalendarEventCard(
                event: event,
                onTap: widget.onEventTap == null
                    ? null
                    : () => widget.onEventTap!(event),
              ),
            ),
          if (showCurrentTime)
            Positioned(
              top: _minutesToOffset(currentMinutes),
              left: 0,
              right: -4,
              child: _CurrentTimeIndicator(
                label: _formatCurrentTime(context, now),
              ),
            ),
        ],
      ),
    );
  }

  /// Uses [MaterialLocalizations] so labels follow
  /// [MediaQueryData.alwaysUse24HourFormat] and locale.
  static String _formatHour(BuildContext context, int hour) {
    return TimeOfDay(hour: hour, minute: 0).format(context);
  }

  static String _formatCurrentTime(BuildContext context, DateTime now) {
    return TimeOfDay.fromDateTime(now).format(context);
  }

  double _minutesToOffset(int minutes) {
    return ((minutes - CalendarTimeLine._startHour * 60) / 60) *
        CalendarTimeLine.hourHeight;
  }

  double _eventHeight(int durationMinutes) {
    final h = (durationMinutes / 60) * CalendarTimeLine.hourHeight - 8;
    return h.clamp(120.0, 800.0);
  }
}

class _HourMarker extends StatelessWidget {
  final double top;
  final double hourHeight;
  final String hourLabel;

  const _HourMarker({
    required this.top,
    required this.hourHeight,
    required this.hourLabel,
  });

  /// Each sub-hour dot represents 12 minutes 30 seconds (12.5 min).
  /// Four dots after the hour mark the 12:30, 25:00, 37:30, 50:00 offsets.
  static const double _dotIntervalMinutes = 12.5;
  static const int _dotCount = 4;
  static const double _dotSize = 4;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: hourHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: CalendarTimeLine._timeColumnWidth - 4,
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Text(
                hourLabel,
                style: GoogleFonts.lato(
                  color: context.palette.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
            height: hourHeight,
            child: Stack(
              children: List.generate(_dotCount, (i) {
                final minutes = _dotIntervalMinutes * (i + 1);
                final dy = (minutes / 60.0) * hourHeight - _dotSize / 2;
                return Positioned(
                  top: dy,
                  left: 4,
                  child: Container(
                    width: _dotSize,
                    height: _dotSize,
                    decoration: BoxDecoration(
                      color: context.palette.divider,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentTimeIndicator extends StatelessWidget {
  final String label;

  const _CurrentTimeIndicator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF6170C9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFF6170C9),
          ),
        ),
      ],
    );
  }
}
