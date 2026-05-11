import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

// ignore: must_be_immutable
class ToggleLabelOption extends StatelessWidget {
  final String label;
  ValueNotifier<bool>? notifierValue;

  final IconData icon;
  final double? margin;

  ToggleLabelOption(
      {Key? key,
      required this.notifierValue,
      required this.label,
      required this.icon,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: notifierValue!,
            builder: (BuildContext context, _, __) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: this.margin ?? 8.0), // 8.0 as default margin.
                child: MergeSemantics(
                    child: ListTile(
                        title: Row(
                          children: [
                            Icon(icon, color: context.palette.textPrimary, size: 24),
                            Text(label,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: context.palette.textPrimary)),
                          ],
                        ),
                        trailing: notifierValue == null
                            ? SizedBox()
                            : CupertinoSwitch(
                                value: notifierValue!.value,
                                activeColor: context.palette.accent,
                                onChanged: (bool value) {
                                  notifierValue!.value = value;
                                },
                              ))),
              );
            }),
        Divider(height: 1, color: context.palette.divider)
        // Divider(height: 1, color: context.palette.textMuted)
      ],
    );
  }
}
