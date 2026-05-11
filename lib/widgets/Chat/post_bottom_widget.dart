import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

class PostBottomWidget extends StatelessWidget {
  final String label;
  const PostBottomWidget({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
            padding: EdgeInsets.only(left: 20),
            width: Utils.screenWidth,
            height: 120,
            decoration: BoxDecoration(
                color: context.palette.background,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Transform.rotate(
                angle: 195.2,
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: context.palette.accent,
                        shape: BoxShape.circle),
                    child:
                        Icon(Icons.attach_file, color: context.palette.textPrimary, size: 30)),
              ),
              AppSpaces.horizontalSpace20,
              Text(label, style: GoogleFonts.lato(color: context.palette.textPrimary))
            ]))));
  }
}
