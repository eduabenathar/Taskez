import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Profile/my_profile.dart';
import 'package:taskez/Screens/Profile/my_team.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_progress_button.dart';
import 'package:taskez/widgets/Dashboard/daily_goal_card.dart';
import 'package:taskez/widgets/Dashboard/productivity_chart.dart';
import 'package:taskez/widgets/Profile/language_selector.dart';
import 'package:taskez/widgets/Buttons/progress_card_close_button.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Profile/badged_container.dart';
import 'package:taskez/widgets/Profile/text_outlined_button.dart';
import 'package:taskez/widgets/container_label.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

import 'profile_notification_settings.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: context.palette.surface,
        position: "topLeft",
      ),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: ProfileDummy(
                  color: HexColor.fromHex("94F0F1"),
                  dummyType: ProfileDummyType.Image,
                  scale: 3.0,
                  image: "assets/man-head.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Blake Gordon",
                  style: GoogleFonts.lato(
                      color: context.palette.textPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            ),
            Text("blake@email.com",
                style: GoogleFonts.lato(
                    color: HexColor.fromHex("B0FFE1"), fontSize: 17)),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButtonWithText(
                width: 150,
                content: l.profileViewProfile,
                onPressed: () {
                  Get.to(() => ProfilePage());
                },
              ),
            ),
            AppSpaces.verticalSpace20,
            ContainerLabel(label: l.profileWorkspace),
            AppSpaces.verticalSpace10,
            Container(
              width: double.infinity,
              height: 90,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: context.palette.background,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileDummy(
                              color: HexColor.fromHex("94F0F1"),
                              dummyType: ProfileDummyType.Image,
                              scale: 1.20,
                              image: "assets/man-head.png"),
                          AppSpaces.horizontalSpace20,
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UI8 Design",
                                    style: GoogleFonts.lato(
                                        color: context.palette.textPrimary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text("hello@ui8.net",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: context.palette.textMuted))
                              ])
                        ]),
                    PrimaryProgressButton(
                      width: 90,
                      height: 40,
                      label: l.profileInvite,
                      textStyle: GoogleFonts.lato(
                          color: context.palette.textPrimary, fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
            AppSpaces.verticalSpace20,
            ContainerLabel(label: l.profileNotification),
            AppSpaces.verticalSpace10,
            BadgedContainer(
              label: l.profileDoNotDisturb,
              callback: () {
                Get.to(() => ProfileNotificationSettings());
              },
              value: l.profileOff,
              badgeColor: "FDA5FF",
            ),
            AppSpaces.verticalSpace20,
            ContainerLabel(label: l.profileManage),
            AppSpaces.verticalSpace10,
            Row(children: [
              Expanded(
                flex: 1,
                child: BadgedContainer(
                  label: l.profileTeam,
                  value: "8",
                  badgeColor: "FDA5FF",
                  callback: () {
                    Get.to(() => MyTeams());
                  },
                ),
              ),
              AppSpaces.horizontalSpace10,
              Expanded(
                flex: 1,
                child: BadgedContainer(
                  label: l.profileLabels,
                  value: "12",
                  badgeColor: "FFDE72",
                ),
              )
            ]),
            AppSpaces.verticalSpace20,
            const LanguageSelector(),
            AppSpaces.verticalSpace20,
            ContainerLabel(label: l.dashboardProductivityTab),
            AppSpaces.verticalSpace10,
            DailyGoalCard(),
            AppSpaces.verticalSpace20,
            ProductivityChart(),
            AppSpaces.verticalSpace20,
            Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: HexColor.fromHex("FF968E"),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(l.profileLogOut,
                      style: GoogleFonts.lato(
                          color: context.palette.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ))
          ])))),
      Positioned(
          top: 50,
          left: 20,
          child: Transform.scale(
              scale: 1.2,
              child: ProgressCardCloseButton(onPressed: () {
                Get.back();
              })))
    ]));
  }
}
