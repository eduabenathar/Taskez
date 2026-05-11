import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:taskez/widgets/Forms/form_input_with%20_label.dart';

import '../container_label.dart';

class MoreTeamDetailsSheet extends StatelessWidget {
  MoreTeamDetailsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final _workSpaceNameController = new TextEditingController();
    final _teamNameController = new TextEditingController();
    return Column(children: [
      AppSpaces.verticalSpace10,
      BottomSheetHolder(),
      AppSpaces.verticalSpace40,
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelledFormInput(
                placeholder: "Blake Gordon",
                keyboardType: "text",
                value: "Blake Gordon",
                controller: _workSpaceNameController,
                obscureText: false,
                label: l.moreTeamWorkSpace),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "Marketing",
                keyboardType: "text",
                controller: _teamNameController,
                obscureText: true,
                label: l.meetingDetailsTeamName),
            AppSpaces.verticalSpace20,
            ContainerLabel(label: l.moreTeamMembers),
            AppSpaces.verticalSpace10,
            Transform.scale(
                alignment: Alignment.centerLeft,
                scale: 0.7,
                child: buildStackedImages(context: context, numberOfMembers: "8", addMore: true)),
          ],
        ),
      ),
    ]);
  }
}
