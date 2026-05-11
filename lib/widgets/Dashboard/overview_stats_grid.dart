import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/overview_stat_card.dart';

class OverviewStatsGrid extends StatelessWidget {
  const OverviewStatsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.15,
      children: [
        OverviewStatCard(
          title: l.overviewDailyTask,
          count: '10',
          label: l.overviewTasksLabel,
          accentColor:
              isDark ? const Color(0xFFA6A4F5) : const Color(0xFF4A48E5),
          backgroundColor:
              isDark ? const Color(0xFF2E2B7A) : const Color(0xFFE3E1FB),
          icon: FeatherIcons.checkSquare,
        ),
        OverviewStatCard(
          title: l.overviewInProgress,
          count: '8',
          label: l.overviewTasksLabel,
          accentColor:
              isDark ? const Color(0xFFE9A5EA) : const Color(0xFFB53AB8),
          backgroundColor:
              isDark ? const Color(0xFF5A1E5C) : const Color(0xFFF5DDF5),
          icon: FeatherIcons.trendingUp,
        ),
        OverviewStatCard(
          title: l.overviewCompleted,
          count: '23',
          label: l.overviewTasksLabel,
          accentColor:
              isDark ? const Color(0xFF8FCDB1) : const Color(0xFF2F8A6B),
          backgroundColor:
              isDark ? const Color(0xFF1F4A38) : const Color(0xFFD8ECDF),
          icon: Icons.check_circle_outline,
        ),
        OverviewStatCard(
          title: l.overviewUpcoming,
          count: '5',
          label: l.overviewTasksLabel,
          accentColor:
              isDark ? const Color(0xFFE8C684) : const Color(0xFFB7842B),
          backgroundColor:
              isDark ? const Color(0xFF5C4416) : const Color(0xFFF6E8CC),
          icon: FeatherIcons.calendar,
        ),
      ],
    );
  }
}
