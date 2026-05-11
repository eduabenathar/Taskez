import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Onboarding/labelled_option.dart';

import 'bottom_sheet_holder.dart';

class ProjectDetailBottomSheet extends StatelessWidget {
  const ProjectDetailBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        AppSpaces.verticalSpace10,
        BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        ListTile(
          title: Text(l.projectSettingsHeader, style: GoogleFonts.lato(fontSize: 12, color: Colors.white30)),
        ),
        Expanded(
          child: ListView(
            children: [
              LabelledOption(label: l.projectSettingsShare, icon: Icons.share),
              LabelledOption(label: l.projectSettingsMarkAllCompleted, icon: Icons.check_circle),
              LabelledOption(label: l.projectSettingsCopy, icon: Icons.tag, link: "taskez.io/6734aw"),
              LabelledOption(label: l.projectSettingsDuplicate, icon: Icons.fiber_smart_record),
              LabelledOption(
                label: l.projectSettingsSetColor,
                icon: Icons.color_lens,
                boxColor: "FFDE72",
              ),
              LabelledOption(label: l.projectSettingsArchive, icon: Icons.archive, color: HexColor.fromHex("C55FFF")),
              LabelledOption(label: l.projectSettingsDelete, icon: FeatherIcons.trash, color: HexColor.fromHex("FC958E")),
            ],
          ),
        ),
      ],
    );
  }
}
