import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_tab_buttons.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Projects/layout_list_tile.dart';
import 'package:taskez/widgets/Projects/project_detail_appbar.dart';
import 'package:taskez/widgets/Projects/project_task_card.dart';
import 'package:taskez/widgets/Shapes/app_settings_icon.dart';

// ignore: must_be_immutable
class ProjectDetails extends StatelessWidget {
  final String color;
  final String projectName;
  final String category;
  ProjectDetails({Key? key, required this.color, required this.projectName, required this.category}) : super(key: key);

  ValueNotifier<int> _settingsButtonTrigger = ValueNotifier(0);
  ValueNotifier<int> _layoutButtonTrigger = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: context.palette.surface,
            position: "topLeft",
          ),
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: SafeArea(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ProjectDetailAppBar(
                  category: category,
                  color: color,
                  iconTapped: (() {
                    showSettingsBottomSheet();
                  }),
                  projectName: projectName,
                ),
                AppSpaces.verticalSpace20,
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  //tab indicators
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PrimaryTabButton(buttonText: l.projectDetailAllTasks, itemIndex: 0, notifier: _settingsButtonTrigger),
                        PrimaryTabButton(buttonText: l.projectsRecentTab, itemIndex: 1, notifier: _settingsButtonTrigger),
                        PrimaryTabButton(buttonText: l.projectDetailStarred, itemIndex: 2, notifier: _settingsButtonTrigger)
                      ],
                    ),
                  ),

                  Container(
                      alignment: Alignment.centerRight,
                      child: AppSettingsIcon(
                        callback: (() {
                          _showLayoutDialog(context);
                        }),
                      ))
                ]),
                AppSpaces.verticalSpace10,
                Expanded(
                    child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(children: [
                    AppSpaces.verticalSpace10,
                    ExpansionTile(
                        initiallyExpanded: true,
                        collapsedIconColor: Colors.white,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        title: Text("IDEAS (3)",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: context.palette.textMuted,
                            )),
                        children: [
                          ProjectTaskCard(
                              activated: true,
                              header: "Orientation",
                              image: "assets/memoji/2.png",
                              backgroundColor: "FCA4FF",
                              date: "Today 12:00PM"),
                          ProjectTaskCard(
                              activated: true,
                              header: "Client Briefing",
                              image: "assets/man-head.png",
                              backgroundColor: "93F0F0",
                              date: "Today 3:00PM"),
                          ProjectTaskCard(
                              activated: false,
                              header: "WireFraming",
                              image: "assets/memoji/9.png",
                              backgroundColor: "8D96FF",
                              date: "Tomorrow 4:15PM"),
                        ]),
                    AppSpaces.verticalSpace10,
                    ExpansionTile(
                        initiallyExpanded: true,
                        collapsedIconColor: Colors.white,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        title: Text("DESIGN (12)",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: context.palette.textMuted,
                            )),
                        children: [
                          ProjectTaskCard(
                              activated: false,
                              header: "Onboarding Screens",
                              image: "assets/memoji/2.png",
                              backgroundColor: "FCA4FF",
                              date: "Today 12:00PM"),
                          ProjectTaskCard(
                              activated: false,
                              header: "Sign In - Sign Up",
                              image: "assets/man-head.png",
                              backgroundColor: "93F0F0",
                              date: "Today 3:00PM"),
                          ProjectTaskCard(
                              activated: false,
                              header: "WireFraming",
                              image: "assets/memoji/9.png",
                              backgroundColor: "8D96FF",
                              date: "Tomorrow 4:15PM"),
                        ])
                  ]),
                ))
              ]),
            ),
          ),
        ],
      ),
    );
  }

  _showLayoutDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l = AppLocalizations.of(context);
        return SimpleDialog(
          insetPadding: EdgeInsets.only(bottom: 500),
          backgroundColor: context.palette.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          children: [
            LayoutListTile(
              notifier: _layoutButtonTrigger,
              index: 0,
              icon: Icons.checklist,
              title: l.projectDetailLayoutList,
            ),
            Divider(height: 1, color: context.palette.divider),
            LayoutListTile(
              notifier: _layoutButtonTrigger,
              index: 1,
              icon: Icons.dashboard,
              title: l.projectDetailLayoutBoard,
            ),
          ],
          /* ... */
        );
      },
    );
  }
}
