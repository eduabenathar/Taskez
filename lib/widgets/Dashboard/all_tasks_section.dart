import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Screens/Dashboard/task_detail_screen.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/all_task_card.dart';

class AllTasksSection extends StatefulWidget {
  const AllTasksSection({Key? key}) : super(key: key);

  @override
  State<AllTasksSection> createState() => _AllTasksSectionState();
}

class _AllTasksSectionState extends State<AllTasksSection> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFFA6A4F5) : const Color(0xFF5B5BF0);
    final activePillBg =
        isDark ? const Color(0xFF262557) : const Color(0xFFE4E3FC);
    final inactivePillBg =
        isDark ? const Color(0xFF2A2D36) : const Color(0xFFF2F3F5);
    final inactivePillText =
        isDark ? const Color(0xFF7E828D) : const Color(0xFF9CA0AB);
    final filters = [
      l.taskFilterToDo,
      l.taskFilterInProgress,
      l.taskFilterInReview,
      l.taskFilterComplete,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l.allTasksTitle,
              style: GoogleFonts.lato(
                color: context.palette.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l.seeAll,
                style: GoogleFonts.lato(
                  color: accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final isActive = i == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? activePillBg : inactivePillBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    filters[i],
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? accent : inactivePillText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppSpaces.verticalSpace20,
        ValueListenableBuilder<List<CalendarEventData>>(
          valueListenable: CalendarStore.instance.events,
          builder: (context, events, _) {
            final filtered = _filteredEvents(events);
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  l.calendarNoMoreTasks,
                  style: GoogleFonts.lato(
                    color: context.palette.textMuted,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final event in filtered)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _EventDashboardCard(event: event),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<CalendarEventData> _filteredEvents(List<CalendarEventData> events) {
    final sorted = [...events]..sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.startMinutes.compareTo(b.startMinutes);
      });
    return sorted.where((e) {
      final progress = _eventProgress(e);
      switch (_selectedFilter) {
        case 0:
          return progress == 0;
        case 1:
          return progress > 0 && progress < 0.7;
        case 2:
          return progress >= 0.7 && progress < 1;
        case 3:
          return progress >= 1;
      }
      return true;
    }).toList();
  }
}

class _EventDashboardCard extends StatelessWidget {
  final CalendarEventData event;

  const _EventDashboardCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final stats = _taskStats(event);
    final visibleAvatars = event.attendeeImages.take(3).toList();
    final date = event.dueDate ?? event.startDate ?? event.date;
    return AllTaskCard(
      title: event.title,
      description: (event.description ?? '').isEmpty
          ? event.location
          : event.description!,
      date: _formatDashboardDate(date, context),
      tasksDone: stats.done,
      tasksTotal: stats.total,
      avatarAssets: visibleAvatars,
      extraAvatars: event.attendeeImages.length > visibleAvatars.length
          ? event.attendeeImages.length - visibleAvatars.length
          : 0,
      commentsCount: event.subtaskGroups
          .fold(0, (sum, group) => sum + group.commentsCount),
      priority: event.priority,
      icon: taskIconData(event.icon),
      onTap: () => Get.to(() => TaskDetailScreen(event: event)),
    );
  }
}

({int done, int total}) _taskStats(CalendarEventData event) {
  final subtasks = event.subtaskGroups.expand((group) => group.subtasks);
  final total = subtasks.length;
  final done = subtasks.where((task) => task.done).length;
  return (done: done, total: total);
}

double _eventProgress(CalendarEventData event) {
  final stats = _taskStats(event);
  if (stats.total == 0) return event.progress.clamp(0.0, 1.0);
  return stats.done / stats.total;
}

String _formatDashboardDate(DateTime date, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(date);
}
