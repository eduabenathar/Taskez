import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
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

  static final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Design System & Component Library',
      'description':
          'Build reusable components, define typography, color styles, and UI guidelines for consistency.',
      'date': 'Oct 03, 2025',
      'done': 0,
      'total': 8,
      'avatarCount': 3,
      'extra': 2,
      'comments': 0,
    },
    {
      'title': 'User Research & Persona Building',
      'description':
          'Conduct interviews, build personas, and define user pain points for better product direction.',
      'date': 'Oct 07, 2025',
      'done': 3,
      'total': 10,
      'avatarCount': 4,
      'extra': 0,
      'comments': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent =
        isDark ? const Color(0xFFA6A4F5) : const Color(0xFF5B5BF0);
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
        ..._tasks.map((t) {
          final count = t['avatarCount'] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AllTaskCard(
              title: t['title'] as String,
              description: t['description'] as String,
              date: t['date'] as String,
              tasksDone: t['done'] as int,
              tasksTotal: t['total'] as int,
              extraAvatars: t['extra'] as int,
              commentsCount: t['comments'] as int,
              avatarAssets: AppData.profileImages.take(count).toList(),
            ),
          );
        }),
      ],
    );
  }
}
