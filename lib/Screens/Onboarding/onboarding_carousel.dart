import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Auth/email_address.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Onboarding/image_outlined_button.dart';
import 'package:taskez/widgets/Onboarding/slider_captioned_image.dart';

class OnboardingCarousel extends StatefulWidget {
  @override
  _OnboardingCarouselState createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? HexColor.fromHex("266FFE") : context.palette.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(children: [
              Container(
                // height: double.infinity,
                // width: double.infinity,
                child: DarkRadialBackground(
                  color: context.palette.surface,
                  position: "bottomRight",
                ),
              ),
              //Buttons positioned below
              Column(children: [
                Container(
                    height: Utils.screenHeight * 1.3,
                    child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          SliderCaptionedImage(
                              index: 0, imageUrl: "assets/slider-background-1.png", caption: l.onboardingSlide1),
                          SliderCaptionedImage(
                              index: 1, imageUrl: "assets/slider-background-3.png", caption: l.onboardingSlide2),
                          SliderCaptionedImage(
                              index: 2,
                              imageUrl: "assets/slider-background-2.png",
                              caption: l.onboardingSlide3)
                        ])),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildPageIndicator(),
                        ),
                        SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => EmailAddressScreen());
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(context.palette.accent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: context.palette.accent)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email, color: context.palette.textPrimary),
                                  Text(l.authContinueWithEmail,
                                      style: GoogleFonts.lato(fontSize: 20, color: context.palette.textPrimary)),
                                ],
                              )),
                        ),
                        SizedBox(height: 10.0),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: OutlinedButtonWithImage(imageUrl: "assets/google_icon.png")),
                          SizedBox(width: 20),
                          Expanded(child: OutlinedButtonWithImage(imageUrl: "assets/facebook_icon.png"))
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(l.onboardingTermsNotice,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(fontSize: 15, color: context.palette.textMuted)),
                        )
                      ]),
                    ),
                  ),
                ),
              ])
            ])));
  }
}
