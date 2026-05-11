import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Chat/chat_screen.dart';
import 'package:taskez/Screens/Profile/profile_overview.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/all_tasks_section.dart';
import 'package:taskez/widgets/Dashboard/currently_project_section.dart';
import 'package:taskez/widgets/Dashboard/overview_stats_grid.dart';
import 'package:taskez/widgets/Navigation/dasboard_header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DashboardNav(
            icon: FontAwesomeIcons.commentDots,
            image: "assets/man-head.png",
            notificationCount: "2",
            page: ChatScreen(),
            title: l.dashboardTitle,
            onImageTapped: () {
              Get.to(() => ProfileOverview());
            },
          ),
          AppSpaces.verticalSpace10,
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dashboardGreeting('Dereck Doyle'),
                      style: GoogleFonts.lato(
                          color: context.palette.textPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  AppSpaces.verticalSpace20,
                  const OverviewStatsGrid(),
                  AppSpaces.verticalSpace20,
                  const CurrentlyProjectSection(),
                  AppSpaces.verticalSpace20,
                  const AllTasksSection(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
