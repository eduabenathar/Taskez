import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Constants/constants.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_progress_button.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Navigation/app_header.dart';
import 'package:taskez/widgets/Onboarding/labelled_option.dart';
import 'package:taskez/widgets/container_label.dart';

class ProfileNotificationSettings extends StatelessWidget {
  ProfileNotificationSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final _assignmedToMe = ValueNotifier(true);
    final _taskCompleted = ValueNotifier(false);
    final _mentionedMe = ValueNotifier(true);
    final _directMessage = ValueNotifier(false);
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
            TaskezAppHeader(
              title: "$tabSpace ${l.notifSettingsTitle}",
              widget: PrimaryProgressButton(
                width: 80,
                height: 40,
                label: l.commonDone,
                textStyle: GoogleFonts.lato(
                    color: context.palette.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            AppSpaces.verticalSpace40,
            Container(
                width: double.infinity,
                height: Utils.screenHeight * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.palette.background),
                child: Column(children: [
                  LabelledOption(
                    label: l.notifSettings30min,
                    icon: Icons.lock_clock,
                  ),
                  LabelledOption(
                    label: l.notifSettings1hour,
                    icon: Icons.lock_clock,
                  ),
                  LabelledOption(
                    label: l.notifSettingsUntilTomorrow,
                    icon: Icons.calendar_today,
                  ),
                  LabelledOption(
                    label: l.notifSettingsUntilNext2Days,
                    icon: Icons.calendar_today,
                  ),
                  LabelledOption(
                    label: l.notifSettingsCustom,
                    icon: Icons.calendar_today,
                  ),
                ])),
            AppSpaces.verticalSpace40,
            ContainerLabel(label: l.notifSettingsNotifyMeAbout),
            AppSpaces.verticalSpace40,
            LabelledCheckbox(
              label: l.notifSettingsTaskAssigned,
              notifierValue: _assignmedToMe,
            ),
            LabelledCheckbox(
                label: l.notifSettingsTaskCompleted, notifierValue: _taskCompleted),
            LabelledCheckbox(
                label: l.notifSettingsMentionedMe, notifierValue: _mentionedMe),
            LabelledCheckbox(
                label: l.notifSettingsDirectMessage, notifierValue: _directMessage),
          ]))))
    ]));
  }
}

class LabelledCheckbox extends StatelessWidget {
  final String label;
  final ValueNotifier<bool>? notifierValue;

  const LabelledCheckbox({
    required this.label,
    Key? key,
    this.notifierValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.lato(color: context.palette.textPrimary, fontSize: 17)),
      Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.grey,
        ),
        child: ValueListenableBuilder(
            valueListenable: notifierValue!,
            builder: (BuildContext context, _, __) {
              return Checkbox(
                  value: notifierValue!.value,
                  activeColor: context.palette.accent,
                  onChanged: (bool? value) => notifierValue!.value = value!);
            }),
      ),
    ]);
  }
}
