import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Forms/form_input_with%20_label.dart';
import 'package:taskez/widgets/Navigation/back.dart';
import 'package:taskez/widgets/Shapes/background_hexagon.dart';

import 'signup.dart';

class EmailAddressScreen extends StatefulWidget {
  @override
  _EmailAddressScreenState createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  TextEditingController _emailController = new TextEditingController();
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
      Positioned(
          top: Utils.screenHeight / 2,
          left: Utils.screenWidth,
          child: Transform.rotate(angle: -math.pi / 2, child: CustomPaint(painter: BackgroundHexagon(color: context.palette.background)))),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NavigationBack(),
          SizedBox(height: 40),
          Text(l.emailAddressTitle,
              style: GoogleFonts.lato(color: context.palette.textPrimary, fontSize: 40, fontWeight: FontWeight.bold)),
          AppSpaces.verticalSpace20,
          LabelledFormInput(
              placeholder: l.authEmailPlaceholder,
              keyboardType: "text",
              controller: _emailController,
              obscureText: obscureText,
              label: l.authEmailLabel),
          SizedBox(height: 40),
          Container(
            //width: 180,
            height: 60,
            child: ElevatedButton(
                onPressed: () {
                  Get.to(() => SignUp(email: _emailController.text));
                },
                style: ButtonStyles.blueRounded(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: context.palette.textInverse),
                    Text(l.authContinueWithEmail, style: GoogleFonts.lato(fontSize: 20, color: context.palette.textInverse)),
                  ],
                )),
          )
        ])),
      )
    ]));
  }
}
