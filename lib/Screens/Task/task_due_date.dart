import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_progress_button.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Navigation/app_header.dart';
import 'package:taskez/widgets/table_calendar.dart';

class TaskDueDate extends StatelessWidget {
  TaskDueDate({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: TaskezAppHeader(title: l.taskDueDate, widget: SizedBox()),
            ),
            SizedBox(height: 40),
            Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecorationStyles.fadingGlory(context),
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DecoratedBox(
                            decoration: BoxDecorationStyles.fadingInnerDecor(context),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  CalendarView(),
                                  AppSpaces.verticalSpace20,
                                  Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: context.palette.background,
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        ConditionText(
                                            label: l.taskDueTime, color: HexColor.fromHex("BE5EF6"), value: "12:30 PM"),
                                        AppSpaces.horizontalSpace20,
                                        AppSpaces.horizontalSpace20,
                                        Container(
                                            width: 0.3, color: context.palette.textMuted, height: double.infinity),
                                        AppSpaces.horizontalSpace20,
                                        AppSpaces.horizontalSpace20,
                                        ConditionText(
                                            label: l.commonRepeat, color: HexColor.fromHex("93EEEE"), value: l.commonNever),
                                      ])),
                                ])))))),
          ])),
      Positioned(
          bottom: 50,
          child: Container(
            padding: EdgeInsets.only(left: 40, right: 20),
            width: Utils.screenWidth,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l.commonCancel,
                  style:
                      GoogleFonts.lato(color: HexColor.fromHex("F49189"), fontSize: 18, fontWeight: FontWeight.bold)),
              PrimaryProgressButton(label: l.commonDone)
            ]),
          ))
    ]));
  }
}

class ConditionText extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const ConditionText({
    required this.label,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.lato(fontSize: 16, color: context.palette.textMuted)),
          AppSpaces.verticalSpace10,
          Text(value, style: GoogleFonts.lato(color: color, fontSize: 20, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
