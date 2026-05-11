import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Constants/constants.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/Buttons/progress_card_close_button.dart';

class TaskProgressCard extends StatelessWidget {
  final String cardTitle;
  final String rating;
  final String progressFigure;
  final int percentageGap;
  TaskProgressCard(
      {Key? key,
      required this.rating,
      required this.cardTitle,
      required this.progressFigure,
      required this.percentageGap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 165,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.palette.shadow,
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ...progressCardGradientList,
            ],
          ),
        ),
        child: Stack(children: [
          Positioned(top: 10, right: 10, child: ProgressCardCloseButton()),
          Positioned(
              top: 30,
              bottom: 20,
              right: 10,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cardTitle,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
                  AppSpaces.verticalSpace10,
                  Text('$rating is completed',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 220,
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: context.palette.textPrimary),
                          child: Row(children: [
                            Expanded(
                                flex: percentageGap,
                                child: Container(
                                    decoration: BoxDecoration(
                                  color: context.palette.textPrimary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ))),
                            Expanded(flex: 1, child: SizedBox())
                          ])),
                      Spacer(),
                      Text("$progressFigure%",
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.black))
                    ],
                  )
                ],
              ))
        ]));
  }
}
