import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:taskez/widgets/Buttons/rect_primary_button.dart';
import 'package:taskez/widgets/Chat/badged_title.dart';
import 'package:taskez/widgets/Forms/form_input_unlabelled.dart';

import '../add_sub_icon.dart';
import 'dashboard_design_meeting_sheet.dart';
import 'in_bottomsheet_subtitle.dart';

class DashboardAddProjectSheet extends StatelessWidget {
  DashboardAddProjectSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final _settingsButtonTrigger = ValueNotifier(0);
    final _projectNameController = new TextEditingController();

    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
            padding: EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              colors: [
                                HexColor.fromHex("FECE91"),
                                HexColor.fromHex("FAEDB9"),
                                HexColor.fromHex("2572FE")
                              ]))),
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: UnlabelledFormInput(
                      placeholder: l.createProjectProjectNamePlaceholder,
                      autofocus: true,
                      keyboardType: "text",
                      controller: _projectNameController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              InBottomSheetSubtitle(title: l.createProjectSelectLayout),
              AppSpaces.verticalSpace10,
              Container(
                  width: double.infinity,
                  height: 60,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.palette.surface),
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: RectPrimaryButtonWithIcon(
                          buttonText: l.projectDetailLayoutList,
                          icon: Icons.checklist,
                          itemIndex: 0,
                          notifier: _settingsButtonTrigger),
                    ),
                    Expanded(
                      flex: 1,
                      child: RectPrimaryButtonWithIcon(
                          buttonText: l.projectDetailLayoutBoard,
                          icon: Icons.checklist,
                          itemIndex: 1,
                          notifier: _settingsButtonTrigger),
                    )
                  ])),
              AppSpaces.verticalSpace20,
              Row(children: [
                BadgedTitle(
                  title: "Design",
                  color: 'FCA3FF',
                  number: '6',
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: context.palette.textPrimary),
                  onPressed: () {},
                )
              ]),
              AppSpaces.verticalSpace10,
              Transform.scale(
                  scale: 0.8,
                  alignment: Alignment.centerLeft,
                  child: buildStackedImages(context: context, numberOfMembers: "2")),
              AppSpaces.verticalSpace20,
              InBottomSheetSubtitle(title: l.createProjectPrivacy),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Text(l.createProjectPublicToDesignTeam,
                        style: GoogleFonts.lato(
                            color: context.palette.textPrimary, fontWeight: FontWeight.w700)),
                    Icon(Icons.expand_more, color: context.palette.textPrimary),
                  ],
                ),
                AddSubIcon(
                  scale: 0.8,
                  color: context.palette.accent,
                  callback: _addMeeting,
                ),
              ]),
            ]))
      ]),
    );
  }

  void _addMeeting() {
    showAppBottomSheet(
      DashboardDesignMeetingSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
