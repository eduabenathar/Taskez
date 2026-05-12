import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Screens/Dashboard/task_detail_screen.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/all_task_card.dart';

class CurrentlyProjectSection extends StatelessWidget {
  const CurrentlyProjectSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.currentlyProjectTitle,
          style: GoogleFonts.lato(
            color: context.palette.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<List<CalendarEventData>>(
          valueListenable: CalendarStore.instance.events,
          builder: (context, events, _) {
            final upcoming = [...events]..sort((a, b) {
                final dateCompare = a.date.compareTo(b.date);
                if (dateCompare != 0) return dateCompare;
                return a.startMinutes.compareTo(b.startMinutes);
              });
            final visible = upcoming.take(5).toList();
            if (visible.isEmpty) {
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

            return SizedBox(
              height: 306,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                itemCount: visible.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return _EventDashboardCard(
                    event: visible[index],
                    width: 320,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EventDashboardCard extends StatelessWidget {
  final CalendarEventData event;
  final double width;

  const _EventDashboardCard({required this.event, required this.width});

  @override
  Widget build(BuildContext context) {
    final stats = _taskStats(event);
    final visibleAvatars = event.attendeeImages.take(3).toList();
    final date = event.dueDate ?? event.startDate ?? event.date;
    return AllTaskCard(
      width: width,
      title: event.title,
      description: (event.description ?? '').isEmpty
          ? event.location
          : event.description!,
      date: _formatDashboardDate(date),
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

String _formatDashboardDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
}
