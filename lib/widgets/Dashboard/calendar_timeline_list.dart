import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';

/// Compact list-style timeline for the selected day.
///
/// Vertical rail with a dot per event; the first (earliest) event of the
/// day is rendered as a dark featured card matching the design reference,
/// the rest as compact text rows with start time on the right.
///
/// If the selected day is today and all events have already ended (or the
/// day has no events at all), a closing "no more tasks" point is appended.
class CalendarTimelineList extends StatelessWidget {
  final List<CalendarEventData> events;
  final DateTime selectedDay;
  final ValueChanged<CalendarEventData>? onEventTap;

  const CalendarTimelineList({
    Key? key,
    required this.events,
    required this.selectedDay,
    this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayEvents = events
        .where((e) => DateUtils.isSameDay(e.date, selectedDay))
        .toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(selectedDay, now);
    final nowMinutes = now.hour * 60 + now.minute;
    final allEnded = dayEvents.isNotEmpty &&
        isToday &&
        dayEvents.every((e) => e.endMinutes <= nowMinutes);
    final showEmptyClosing = dayEvents.isEmpty || allEnded;

    final l = AppLocalizations.of(context);

    final items = <Widget>[];
    for (var i = 0; i < dayEvents.length; i++) {
      items.add(
        _TimelineRow(
          isFirst: i == 0,
          isLast: i == dayEvents.length - 1 && !showEmptyClosing,
          rail: _RailDot(filled: i == 0 && !allEnded),
          child: i == 0
              ? _FeaturedEventCard(
                  event: dayEvents[i],
                  onTap: onEventTap == null
                      ? null
                      : () => onEventTap!(dayEvents[i]),
                )
              : _CompactRow(
                  event: dayEvents[i],
                  onTap: onEventTap == null
                      ? null
                      : () => onEventTap!(dayEvents[i]),
                ),
        ),
      );
    }

    if (showEmptyClosing) {
      items.add(
        _TimelineRow(
          isFirst: dayEvents.isEmpty,
          isLast: true,
          rail: const _RailDot(filled: true),
          child: _EmptyClosingRow(label: l.calendarNoMoreTasks),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Widget rail;
  final Widget child;

  const _TimelineRow({
    required this.isFirst,
    required this.isLast,
    required this.rail,
    required this.child,
  });

  static const double _railWidth = 36;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _railWidth,
            child: _Rail(
              isFirst: isFirst,
              isLast: isLast,
              dot: rail,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 0, isLast ? 4 : 22),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Widget dot;

  const _Rail({
    required this.isFirst,
    required this.isLast,
    required this.dot,
  });

  static const double _topPadding = 6;
  static const double _dotSize = 16;

  @override
  Widget build(BuildContext context) {
    final lineColor = context.palette.textPrimary.withValues(alpha: 0.85);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: isFirst ? _topPadding + _dotSize / 2 : 0,
          bottom: isLast ? null : 0,
          height: isLast ? 0 : null,
          child: Container(width: 1.4, color: lineColor),
        ),
        if (!isLast || isFirst)
          // ensures we have a visible line from the dot down through the row
          const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(top: _topPadding),
          child: dot,
        ),
      ],
    );
  }
}

class _RailDot extends StatelessWidget {
  final bool filled;
  const _RailDot({required this.filled});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = palette.textPrimary.withValues(alpha: 0.7);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: filled ? palette.textPrimary : palette.surface,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.6),
      ),
    );
  }
}

class _FeaturedEventCard extends StatelessWidget {
  final CalendarEventData event;
  final VoidCallback? onTap;

  const _FeaturedEventCard({required this.event, required this.onTap});

  static const _bg = Color(0xFF1C1C1E);
  static const _muted = Color(0xCCFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _startLabel(event.startMinutes),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: _muted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _AttendeeStack(images: event.attendeeImages),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      taskIconData(event.icon),
                      color: const Color(0xFF1C1C1E),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendeeStack extends StatelessWidget {
  final List<String> images;
  const _AttendeeStack({required this.images});

  @override
  Widget build(BuildContext context) {
    const avatarSize = 30.0;
    const overlap = 18.0;
    final visible = images.take(4).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * overlap,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: AssetImage(visible[i]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactRow extends StatelessWidget {
  final CalendarEventData event;
  final VoidCallback? onTap;

  const _CompactRow({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: event.accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      taskIconData(event.icon),
                      color: event.accentColor,
                      size: 19,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: palette.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _startLabel(event.startMinutes),
                    style: GoogleFonts.lato(
                      color: palette.textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: palette.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyClosingRow extends StatelessWidget {
  final String label;
  const _EmptyClosingRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
      child: Text(
        label,
        style: GoogleFonts.lato(
          color: context.palette.textMuted,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _startLabel(int minutes) {
  final h24 = (minutes ~/ 60) % 24;
  final m = minutes % 60;
  final period = h24 >= 12 ? 'PM' : 'AM';
  final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
  final mm = m.toString().padLeft(2, '0');
  return '$h12.$mm $period';
}
