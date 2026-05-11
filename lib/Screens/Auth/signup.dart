import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Forms/form_input_with%20_label.dart';
import 'package:taskez/widgets/Navigation/back.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  final String email;
  const SignUp({required this.email});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  bool obscureText = false;

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
          padding: EdgeInsets.all(20.0),
          child: SafeArea(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            NavigationBack(),
            SizedBox(height: 40),
            Text(l.signupTitle, style: GoogleFonts.lato(color: context.palette.textPrimary, fontSize: 40, fontWeight: FontWeight.bold)),
            AppSpaces.verticalSpace20,
            RichText(
              text: TextSpan(
                text: l.loginUsingPrefix,
                style: GoogleFonts.lato(color: context.palette.textMuted),
                children: <TextSpan>[
                  TextSpan(text: widget.email, style: TextStyle(color: context.palette.textSecondary, fontWeight: FontWeight.bold)),
                  TextSpan(text: l.loginUsingSuffix, style: GoogleFonts.lato(color: context.palette.textMuted)),
                ],
              ),
            ),
            SizedBox(height: 30),
            LabelledFormInput(
                placeholder: l.authNamePlaceholder,
                keyboardType: "text",
                controller: _nameController,
                obscureText: obscureText,
                label: l.authNameLabel),
            SizedBox(height: 15),
            LabelledFormInput(
                placeholder: l.authPasswordPlaceholder,
                keyboardType: "text",
                controller: _passController,
                obscureText: obscureText,
                label: l.authPasswordLabel),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => Login(email: widget.email));
                  },
                  style: ButtonStyles.blueRounded(context),
                  child: Text(l.signupButton, style: GoogleFonts.lato(fontSize: 20, color: context.palette.textInverse))),
            )
          ])))
    ]));
  }
}
