import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/currently_project_card.dart';

class CurrentlyProjectSection extends StatelessWidget {
  const CurrentlyProjectSection({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Smart Personal Finance Tracker App',
      'date': 'Sept 13, 2025',
      'done': 9,
      'total': 12,
      'comments': 8,
    },
    {
      'title': 'AI-Powered Learning Platform',
      'date': 'Oct 02, 2025',
      'done': 5,
      'total': 14,
      'comments': 12,
    },
    {
      'title': 'Remote Team Collaboration Suite',
      'date': 'Nov 21, 2025',
      'done': 18,
      'total': 22,
      'comments': 3,
    },
  ];

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
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 14),
            itemCount: _projects.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final p = _projects[index];
              return Center(
                child: CurrentlyProjectCard(
                  title: p['title'] as String,
                  date: p['date'] as String,
                  tasksDone: p['done'] as int,
                  tasksTotal: p['total'] as int,
                  commentsCount: p['comments'] as int,
                  avatarAssets: AppData.profileImages,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
