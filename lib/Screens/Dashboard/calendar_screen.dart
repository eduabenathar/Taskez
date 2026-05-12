import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Screens/Dashboard/task_detail_screen.dart';
import 'package:taskez/Screens/Profile/profile_overview.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/calendar_day_strip.dart';
import 'package:taskez/widgets/Dashboard/calendar_event_form_sheet.dart';
import 'package:taskez/widgets/Dashboard/calendar_month_grid.dart';
import 'package:taskez/widgets/Dashboard/calendar_time_line.dart';
import 'package:taskez/widgets/Dashboard/calendar_timeline_list.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  late DateTime _visibleMonth = DateTime(_selectedDay.year, _selectedDay.month);
  int _direction = 1;
  bool _monthExpanded = false;
  bool _useDots = false;
  Timer? _headerTick;

  @override
  void initState() {
    super.initState();
    _headerTick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _headerTick?.cancel();
    super.dispose();
  }

  void _selectDay(DateTime day) {
    final next = DateUtils.dateOnly(day);
    if (DateUtils.isSameDay(next, _selectedDay)) return;
    setState(() {
      _direction = next.isAfter(_selectedDay) ? 1 : -1;
      _selectedDay = next;
      _visibleMonth = DateTime(next.year, next.month);
    });
  }

  void _shiftVisibleMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _toggleMonthExpanded([bool? value]) {
    setState(() {
      _monthExpanded = value ?? !_monthExpanded;
      if (_monthExpanded) {
        _visibleMonth = DateTime(_selectedDay.year, _selectedDay.month);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity ?? 0;
    if (v > 220 && !_monthExpanded) {
      _toggleMonthExpanded(true);
    } else if (v < -220 && _monthExpanded) {
      _toggleMonthExpanded(false);
    }
  }

  /// In the 24h grid mode, always scroll so the current hour sits near
  /// the top of the viewport — regardless of which day is selected.
  /// The timeline (dots) mode always starts at 0.
  double _computeInitialScrollOffset() {
    if (_useDots) return 0;
    return DateTime.now().hour * CalendarTimeLine.hourHeight;
  }

  Future<void> _openForm({
    CalendarEventData? existing,
    DateTime? initialDate,
    int? initialStartMinutes,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => CalendarEventFormSheet(
        initialDate: initialDate ?? _selectedDay,
        initialStartMinutes: initialStartMinutes,
        existing: existing,
      ),
    );
  }

  /// Maps a local Y offset within the hour timeline to a snapped start time
  /// (rounded to the nearest 15 minutes).
  int _minutesFromOffset(double localY) {
    final raw = (localY / CalendarTimeLine.hourHeight) * 60;
    final snapped = (raw / 15).round() * 15;
    return snapped.clamp(0, 23 * 60 + 45);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final l = AppLocalizations.of(context);
    final isToday = DateUtils.isSameDay(_selectedDay, DateTime.now());
    final smallDate = DateFormat.yMMMMd(locale).format(_selectedDay);
    final bigTitle = isToday
        ? l.commonToday
        : _formatWeekday(DateFormat.EEEE(locale).format(_selectedDay));
    final palette = context.palette;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CalendarHeader(
                smallDate: smallDate,
                bigTitle: bigTitle,
                isToday: isToday,
                onAddTap: () => _openForm(),
                onProfileTap: () => Get.to(() => ProfileOverview()),
                onTodayTap: () => _selectDay(DateTime.now()),
              ),
              AppSpaces.verticalSpace10,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragEnd: _handleDragEnd,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: child,
                      ),
                    ),
                    child: _monthExpanded
                        ? KeyedSubtree(
                            key: const ValueKey('month'),
                            child: CalendarMonthGrid(
                              visibleMonth: _visibleMonth,
                              selectedDay: _selectedDay,
                              onDaySelected: (d) {
                                _selectDay(d);
                                _toggleMonthExpanded(false);
                              },
                              onPrevMonth: () => _shiftVisibleMonth(-1),
                              onNextMonth: () => _shiftVisibleMonth(1),
                            ),
                          )
                        : KeyedSubtree(
                            key: const ValueKey('week'),
                            child: CalendarDayStrip(
                              selectedDay: _selectedDay,
                              onDaySelected: _selectDay,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              _ExpandGrabber(
                expanded: _monthExpanded,
                onTap: () => _toggleMonthExpanded(),
                palette: palette,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: _TimelineFormatSelect(
                  useDots: _useDots,
                  onSelect: (v) {
                    if (_useDots == v) return;
                    setState(() => _useDots = v);
                  },
                  dotsLabel: l.calendarViewDots,
                  hoursLabel: l.calendarViewHours,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ValueListenableBuilder<List<CalendarEventData>>(
                  valueListenable: CalendarStore.instance.events,
                  builder: (context, _, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      layoutBuilder: (currentChild, previousChildren) => Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      ),
                      transitionBuilder: (child, animation) {
                        final incoming =
                            child.key == ValueKey('$_selectedDay-$_useDots');
                        final beginOffset = Offset(
                          incoming ? 0.12 * _direction : -0.12 * _direction,
                          0,
                        );
                        final slide = Tween<Offset>(
                          begin: beginOffset,
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey('$_selectedDay-$_useDots'),
                        child: _ResettingScroll(
                          padding: const EdgeInsets.only(top: 16, bottom: 140),
                          initialOffset: _computeInitialScrollOffset(),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onLongPressStart: (details) {
                              final minutes = _useDots
                                  ? null
                                  : _minutesFromOffset(
                                      details.localPosition.dy);
                              _openForm(
                                initialDate: _selectedDay,
                                initialStartMinutes: minutes,
                              );
                            },
                            child: _useDots
                                ? CalendarTimelineList(
                                    events: CalendarStore.instance.events.value,
                                    selectedDay: _selectedDay,
                                    onEventTap: (e) => Get.to(
                                        () => TaskDetailScreen(event: e)),
                                  )
                                : CalendarTimeLine(
                                    events: CalendarStore.instance.events.value,
                                    selectedDay: _selectedDay,
                                    onEventTap: (e) => Get.to(
                                        () => TaskDetailScreen(event: e)),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatWeekday(String raw) {
  var s = raw.replaceAll(RegExp(r'-?feira', caseSensitive: false), '').trim();
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

class _CalendarHeader extends StatelessWidget {
  final String smallDate;
  final String bigTitle;
  final bool isToday;
  final VoidCallback onAddTap;
  final VoidCallback onProfileTap;
  final VoidCallback onTodayTap;

  const _CalendarHeader({
    required this.smallDate,
    required this.bigTitle,
    required this.isToday,
    required this.onAddTap,
    required this.onProfileTap,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                smallDate,
                style: GoogleFonts.lato(
                  color: palette.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Text(
                  bigTitle,
                  key: ValueKey(bigTitle),
                  style: GoogleFonts.lato(
                    color: palette.textPrimary,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isToday)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: onTodayTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.commonToday,
                  style: GoogleFonts.lato(
                    color: palette.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        _HeaderAddButton(onTap: onAddTap),
        const SizedBox(width: 12),
        InkWell(
          onTap: onProfileTap,
          customBorder: const CircleBorder(),
          child: ProfileDummy(
            color: HexColor.fromHex("93F0F0"),
            dummyType: ProfileDummyType.Image,
            image: "assets/man-head.png",
            scale: 1.2,
          ),
        ),
      ],
    );
  }
}

class _ExpandGrabber extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;
  final AppPalette palette;

  const _ExpandGrabber({
    required this.expanded,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: palette.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.add,
            size: 22,
            color: palette.iconPrimary,
          ),
        ),
      ),
    );
  }
}

/// Hosts a fresh [ScrollController] and jumps to [initialOffset] after the
/// first layout pass, whenever the parent recreates this widget — i.e.,
/// when the selected day or timeline format changes, or when the calendar
/// screen is first opened. Other days/modes pass 0; today's 24h grid
/// passes the current hour's Y so the view opens around "now".
class _ResettingScroll extends StatefulWidget {
  final EdgeInsets padding;
  final double initialOffset;
  final Widget child;

  const _ResettingScroll({
    required this.padding,
    required this.initialOffset,
    required this.child,
  });

  @override
  State<_ResettingScroll> createState() => _ResettingScrollState();
}

class _ResettingScrollState extends State<_ResettingScroll> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: widget.initialOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      final target = widget.initialOffset.clamp(0.0, max);
      if ((_controller.offset - target).abs() > 0.5) {
        _controller.jumpTo(target);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      padding: widget.padding,
      child: widget.child,
    );
  }
}

class _TimelineFormatSelect extends StatelessWidget {
  final bool useDots;
  final ValueChanged<bool> onSelect;
  final String dotsLabel;
  final String hoursLabel;

  const _TimelineFormatSelect({
    required this.useDots,
    required this.onSelect,
    required this.dotsLabel,
    required this.hoursLabel,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final currentLabel = useDots ? dotsLabel : hoursLabel;

    return PopupMenuButton<bool>(
      tooltip: '',
      onSelected: onSelect,
      initialValue: useDots,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 6),
      color: palette.surfaceElevated,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      itemBuilder: (context) => [
        _menuItem(false, hoursLabel, !useDots, palette),
        _menuItem(true, dotsLabel, useDots, palette),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLabel,
              style: GoogleFonts.lato(
                color: palette.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: palette.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<bool> _menuItem(
    bool value,
    String label,
    bool selected,
    AppPalette palette,
  ) {
    return PopupMenuItem<bool>(
      value: value,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.lato(
                color: selected ? palette.accent : palette.textPrimary,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          if (selected) Icon(Icons.check, size: 18, color: palette.accent),
        ],
      ),
    );
  }
}
