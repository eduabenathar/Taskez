import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Dashboard/timeline.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Forms/form_input_with%20_label.dart';
import 'package:taskez/widgets/Navigation/back.dart';

class Login extends StatefulWidget {
  final String email;

  const Login({Key? key, required this.email}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passController = new TextEditingController();
  bool obscureText = false;
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l = AppLocalizations.of(context);
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: palette.surface,
        position: "topLeft",
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationBack(),
            SizedBox(height: 40),
            Text(l.loginTitle, style: GoogleFonts.lato(color: palette.textPrimary, fontSize: 40, fontWeight: FontWeight.bold)),
            AppSpaces.verticalSpace20,
            RichText(
              text: TextSpan(
                text: l.loginUsingPrefix,
                style: GoogleFonts.lato(color: palette.textMuted),
                children: <TextSpan>[
                  TextSpan(text: widget.email, style: TextStyle(color: palette.textSecondary, fontWeight: FontWeight.bold)),
                  TextSpan(text: l.loginUsingSuffix, style: GoogleFonts.lato(color: palette.textMuted)),
                ],
              ),
            ),
            SizedBox(height: 30),
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
                    Get.to(() => Timeline());
                  },
                  style: ButtonStyles.blueRounded(context),
                  child: Text(l.loginSignInButton, style: GoogleFonts.lato(fontSize: 20, color: palette.textInverse))),
            )
          ],
        )),
      )
    ]));
  }
}
