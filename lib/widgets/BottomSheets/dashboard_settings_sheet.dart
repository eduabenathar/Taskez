import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_buttons.dart';
import 'package:taskez/widgets/Buttons/text_button.dart';
import 'package:taskez/widgets/Onboarding/toggle_option.dart';

import 'bottom_sheet_holder.dart';

class DashboardSettingsBottomSheet extends StatelessWidget {
  final ValueNotifier<bool> totalTaskNotifier;
  final ValueNotifier<bool> totalDueNotifier;
  final ValueNotifier<bool> totalCompletedNotifier;
  final ValueNotifier<bool> workingOnNotifier;
  const DashboardSettingsBottomSheet(
      {Key? key,
      required this.totalTaskNotifier,
      required this.totalDueNotifier,
      required this.totalCompletedNotifier,
      required this.workingOnNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(children: [
      AppSpaces.verticalSpace10,
      BottomSheetHolder(),
      AppSpaces.verticalSpace20,
      ToggleLabelOption(label: '    ${l.dashboardSettingsTotalTask}', notifierValue: totalTaskNotifier, icon: Icons.check_circle_outline),
      ToggleLabelOption(label: '    ${l.dashboardSettingsTaskDueSoon}', notifierValue: totalDueNotifier, icon: Icons.batch_prediction),
      ToggleLabelOption(label: '    ${l.dashboardSettingsCompleted}', notifierValue: totalCompletedNotifier, icon: Icons.check_circle),
      ToggleLabelOption(label: '    ${l.dashboardSettingsWorkingOn}', notifierValue: workingOnNotifier, icon: Icons.flag),
      Spacer(),
      Padding(
        padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AppTextButton(
            buttonText: l.dashboardSettingsClearAll,
            buttonSize: 16,
          ),
          AppPrimaryButton(
            buttonHeight: 60,
            buttonWidth: 160,
            buttonText: l.dashboardSettingsSaveChanges,
          )
        ]),
      )
    ]);
  }
}
