import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Screens/Chat/messaging_screen.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Chat/post_bottom_widget.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Dashboard/in_bottomsheet_subtitle.dart';
import 'package:taskez/widgets/Dashboard/sheet_goto_calendar.dart';
import 'package:taskez/widgets/Navigation/back_button.dart';
import 'package:taskez/widgets/Notification/notification_card.dart';
import 'package:taskez/widgets/Projects/project_badge.dart';
import 'package:taskez/widgets/Projects/project_selectable_container.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dynamic notificationData = AppData.notificationMentions;

    List<Widget> notificationCards = List.generate(
        3,
        (index) => NotificationCard(
              read: notificationData[index]['read'],
              userName: notificationData[index]['mentionedBy'],
              date: notificationData[index]['date'],
              image: notificationData[index]['profileImage'],
              mentioned: notificationData[index]['hashTagPresent'],
              message: notificationData[index]['message'],
              mention: notificationData[index]['mentionedIn'],
              imageBackground: notificationData[index]['color'],
              userOnline: notificationData[index]['userOnline'],
            ));
    final List<String> sentImage = [
      "assets/slider-background-1.png",
      "assets/slider-background-2.png",
      "assets/slider-background-3.png"
    ];

    List<SentImage> imageCards = List.generate(
        sentImage.length, (index) => SentImage(image: sentImage[index]));

    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: context.palette.surface,
        position: "topLeft",
      ),

      // listView
      Positioned(
          top: 80,
          child: Container(
              padding: EdgeInsets.all(20),
              width: Utils.screenWidth,
              height: Utils.screenHeight * 2,
              child: ListView(children: [
                Text("Onboarding\n Screens",
                    style: GoogleFonts.lato(
                        fontSize: 40,
                        color: context.palette.textPrimary,
                        fontWeight: FontWeight.bold)),
                AppSpaces.verticalSpace20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileDummy(
                                    color: HexColor.fromHex("94F0F1"),
                                    dummyType: ProfileDummyType.Image,
                                    scale: 1.5,
                                    image: "assets/man-head.png"),
                                AppSpaces.horizontalSpace10,
                                CircularCardLabel(
                                  label: l.createProjectAssignedTo,
                                  value: 'Dereck Boyle',
                                  color: context.palette.textPrimary,
                                )
                              ]),
                          SheetGoToCalendarWidget(
                            cardBackgroundColor: context.palette.accent,
                            textAccentColor: HexColor.fromHex("E89EE9"),
                            value: 'Nov 10',
                            label: l.taskDueDate,
                          ),
                        ]),
                    AppSpaces.verticalSpace20,
                    Row(
                      children: [
                        ColouredProjectBadge(
                            color: "A06AFA", category: "Task List"),
                        AppSpaces.horizontalSpace20,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Unity Dashboard",
                                  style: GoogleFonts.lato(
                                      color: context.palette.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 5),
                              Text("Task List",
                                  style: GoogleFonts.lato(
                                      color: context.palette.textMuted)),
                            ])
                      ],
                    ),
                  ],
                ),
                AppSpaces.verticalSpace40,
                InBottomSheetSubtitle(
                  title: l.createProjectDescription,
                  textStyle: GoogleFonts.lato(color: context.palette.textPrimary),
                ),
                AppSpaces.verticalSpace10,
                InBottomSheetSubtitle(
                    title: "4.648 curated design resources to energize your",
                    textStyle: GoogleFonts.lato(
                        fontSize: 15, color: context.palette.textMuted)),
                AppSpaces.verticalSpace10,
                InBottomSheetSubtitle(
                    title: "creative workflow.",
                    textStyle: GoogleFonts.lato(
                        fontSize: 15, color: context.palette.textMuted)),
                AppSpaces.verticalSpace40,
                ProjectSelectableContainer(
                  activated: false,
                  header: "Sub task completed ",
                ),
                ProjectSelectableContainer(
                  activated: true,
                  header: "Unity Gaming ",
                ),
                AppSpaces.verticalSpace40,
                Container(
                  height: 120,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [...imageCards]),
                ),
                AppSpaces.verticalSpace40,
                AppSpaces.verticalSpace40,
                ...notificationCards
              ]))),

      Positioned(
        top: 0,
        child: Container(
          child: ClipRect(
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 20),
              child: Container(
                width: Utils.screenWidth,
                padding: EdgeInsets.all(20),
                height: 120.0,
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppBackButton(),
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                              IconButton(
                                icon: Icon(Icons.done),
                                color: context.palette.textPrimary,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                              AppSpaces.horizontalSpace10,
                              IconButton(
                                icon: Icon(Icons.dns_outlined),
                                color: context.palette.textPrimary,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                              AppSpaces.horizontalSpace10,
                              IconButton(
                                icon: Icon(Icons.thumb_up_outlined),
                                color: context.palette.textPrimary,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                              AppSpaces.horizontalSpace10,
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                color: context.palette.textPrimary,
                                iconSize: 30,
                                onPressed: () {
                                  showSettingsBottomSheet();
                                },
                              )
                            ]))
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
      //last widget
      PostBottomWidget(label: l.createProjectCommentPlaceholder)
    ]));
  }
}
