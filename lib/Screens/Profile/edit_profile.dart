import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_progress_button.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Forms/form_input_with%20_label.dart';
import 'package:taskez/widgets/Navigation/app_header.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final String tabSpace = "\t\t\t";
    final _nameController = new TextEditingController();
    final _passController = new TextEditingController();
    final _emailController = new TextEditingController();
    final _roleController = new TextEditingController();
    final _aboutController = new TextEditingController();
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
              title: "$tabSpace ${l.editProfileTitle}",
              widget: PrimaryProgressButton(
                width: 80,
                height: 40,
                label: l.commonDone,
                textStyle: GoogleFonts.lato(
                    color: context.palette.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                ProfileDummy(
                    color: HexColor.fromHex("94F0F1"),
                    dummyType: ProfileDummyType.Image,
                    scale: 3.0,
                    image: "assets/man-head.png"),
                Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: context.palette.accent.withOpacity(0.75),
                        shape: BoxShape.circle),
                    child: Icon(FeatherIcons.camera,
                        color: context.palette.textPrimary, size: 20))
              ],
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "Blake Gordon",
                keyboardType: "text",
                controller: _nameController,
                obscureText: false,
                label: l.authNameLabel),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "blake@gmail.com",
                keyboardType: "text",
                controller: _emailController,
                obscureText: true,
                label: l.authEmailLabel),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "HikLHjD@&1?>",
                keyboardType: "text",
                controller: _passController,
                obscureText: true,
                label: l.authPasswordLabel),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "Visual Designer",
                keyboardType: "text",
                controller: _roleController,
                obscureText: true,
                label: l.editProfileRole),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                placeholder: "Design & Cat Person",
                keyboardType: "text",
                controller: _aboutController,
                obscureText: true,
                label: l.editProfileAboutMe),
          ]))))
    ]));
  }
}
