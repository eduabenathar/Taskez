import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        height: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: context.palette.background),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //left side
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dailyGoalTitle,
                      style: GoogleFonts.lato(
                          color: context.palette.textMuted,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                  AppSpaces.verticalSpace10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("8ACA72"),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Center(
                            child: Text('3/5',
                                style: GoogleFonts.lato(
                                  color: context.palette.textPrimary,
                                  fontSize: 16,
                                )),
                          )),
                      AppSpaces.horizontalSpace10,
                      Text(l.dailyGoalTasks,
                          style: GoogleFonts.lato(
                              color: context.palette.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  AppSpaces.verticalSpace10,
                  Text(l.dailyGoalProgress,
                      style: GoogleFonts.lato(
                          color: context.palette.textMuted,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                  AppSpaces.verticalSpace20,
                  Container(
                    width: 120,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HexColor.fromHex("C25FFF")),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(
                                        color: HexColor.fromHex("C25FFF"))))),
                        child: Text(l.dailyGoalAllTask,
                            style: GoogleFonts.lato(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: context.palette.textPrimary))),
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 8, color: context.palette.surfaceElevated)),
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: Image(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                "assets/small-logo.png",
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 0.80),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, _) => Container(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                              strokeWidth: 8,
                              value: value,
                              color: HexColor.fromHex("8FFFCF")),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]));
  }
}
