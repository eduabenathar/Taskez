import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Projects/set_members.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_selectable_container.dart';
import 'package:taskez/widgets/Buttons/primary_buttons.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

import 'in_bottomsheet_subtitle.dart';

class DashboardMeetingDetails extends StatelessWidget {
  const DashboardMeetingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          AppSpaces.verticalSpace10,
          BottomSheetHolder(),
          AppSpaces.verticalSpace20,
          Align(
            alignment: Alignment.center,
            child: ProfileDummy(
                color: HexColor.fromHex("9F69F9"),
                dummyType: ProfileDummyType.Image,
                scale: 2.5,
                image: "assets/plant.png"),
          ),
          AppSpaces.verticalSpace10,
          InBottomSheetSubtitle(
            title: "Marketing",
            alignment: Alignment.center,
            textStyle: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              fontSize: 26,
              color: context.palette.textPrimary,
            ),
          ),
          AppSpaces.verticalSpace10,
          InBottomSheetSubtitle(
            title: l.meetingDetailsUploadLogo,
            alignment: Alignment.center,
          ),
          AppSpaces.verticalSpace20,
          LabelledSelectableContainer(
            label: l.meetingDetailsTeamName,
            value: "Marketing",
            icon: Icons.share,
          ),
          AppSpaces.verticalSpace20,
          LabelledSelectableContainer(
            label: l.meetingDetailsMember,
            value: l.meetingDetailsSelectMembers,
            icon: Icons.add,
            valueColor: context.palette.accent,
          ),
          AppSpaces.verticalSpace20,
          LabelledSelectableContainer(
            label: l.meetingDetailsPrivacy,
            value: l.meetingDetailsPublic,
            icon: Icons.expand_more,
            containerColor: HexColor.fromHex("A06AF9"),
          ),
          AppSpaces.verticalSpace40,
          AppPrimaryButton(
              buttonHeight: 50,
              buttonWidth: 180,
              buttonText: l.meetingDetailsCreateNewTeam,
              callback: () {
                Get.to(() => SelectMembersScreen());
              }),
          AppSpaces.verticalSpace20,
        ]),
      ),
    );
  }
}
