import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Screens/Projects/create_project.dart';
import 'package:taskez/Screens/Projects/set_members.dart';
import 'package:taskez/Screens/Task/task_due_date.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:taskez/widgets/Onboarding/labelled_option.dart';

import 'create_task.dart';

class DashboardAddBottomSheet extends StatelessWidget {
  const DashboardAddBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(children: [
      AppSpaces.verticalSpace10,
      BottomSheetHolder(),
      AppSpaces.verticalSpace10,
      LabelledOption(
        label: l.dashboardAddCreateTask,
        icon: Icons.add_to_queue,
        callback: _createTask,
      ),
      LabelledOption(
          label: l.dashboardAddCreateProject,
          icon: Icons.device_hub,
          callback: () {
            Get.to(() => CreateProjectScreen());
          }),
      LabelledOption(
          label: l.dashboardAddCreateTeam,
          icon: Icons.people,
          callback: () {
            Get.to(() => SelectMembersScreen());
          }),
      LabelledOption(
          label: l.dashboardAddCreateEvent,
          icon: Icons.fiber_smart_record,
          callback: () {
            Get.to(() => TaskDueDate());
          }),
    ]);
  }

  void _createTask() {
    showAppBottomSheet(
      CreateTaskBottomSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
