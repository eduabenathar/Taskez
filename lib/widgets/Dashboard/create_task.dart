import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Screens/Task/set_assignees.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:taskez/widgets/Dashboard/sheet_goto_calendar.dart';
import 'package:taskez/widgets/Forms/form_input_unlabelled.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

import '../add_sub_icon.dart';
import 'dashboard_add_project_sheet.dart';

// ignore: must_be_immutable
class CreateTaskBottomSheet extends StatelessWidget {
  CreateTaskBottomSheet({Key? key}) : super(key: key);

  TextEditingController _taskNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.contacts, color: context.palette.textPrimary),
              AppSpaces.horizontalSpace10,
              Text("Unity Dashboard  ", style: GoogleFonts.lato(color: context.palette.textPrimary, fontWeight: FontWeight.w700)),
              Icon(Icons.expand_more, color: context.palette.textPrimary),
            ]),
            AppSpaces.verticalSpace20,
            Row(
              children: [
                Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [HexColor.fromHex("FD916E"), HexColor.fromHex("FFE09B")]))),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: UnlabelledFormInput(
                    placeholder: l.createTaskTaskNamePlaceholder,
                    autofocus: true,
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                onTap: () {
                  Get.to(() => SetAssigneesScreen());
                },
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              ),
              SheetGoToCalendarWidget(
                cardBackgroundColor: HexColor.fromHex("7DBA67"),
                textAccentColor: HexColor.fromHex("A9F49C"),
                value: 'Today 3:00PM',
                label: l.taskDueDate,
              )
            ]),
            // Spacer(),
            AppSpaces.verticalSpace20,

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                width: Utils.screenWidth * 0.6,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  BottomSheetIcon(icon: Icons.local_offer_outlined),
                  Transform.rotate(angle: 195.2, child: BottomSheetIcon(icon: Icons.attach_file)),
                  BottomSheetIcon(icon: FeatherIcons.flag),
                  BottomSheetIcon(icon: FeatherIcons.image)
                ]),
              ),
              AddSubIcon(
                scale: 0.8,
                color: context.palette.accent,
                callback: _addProject,
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  void _addProject() {
    showAppBottomSheet(
      DashboardAddProjectSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;
  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: context.palette.textPrimary,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
