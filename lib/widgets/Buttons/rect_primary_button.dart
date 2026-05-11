import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

class RectPrimaryButtonWithIcon extends StatelessWidget {
  final String buttonText;
  final IconData? icon;
  final int itemIndex;
  final ValueNotifier<int> notifier;
  final VoidCallback? callback;
  const RectPrimaryButtonWithIcon(
      {Key? key, this.callback, this.icon, required this.notifier, required this.buttonText, required this.itemIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (BuildContext context, _, __) {
            final selected = notifier.value == itemIndex;
            final bg = selected ? palette.accent : palette.surface;
            return ElevatedButton(
                onPressed: () {
                  notifier.value = itemIndex;
                  if (callback != null) callback!();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(bg),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: selected ? palette.accent : palette.surface)))),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) Icon(icon!, color: selected ? palette.textInverse : palette.textPrimary),
                      Text("   $buttonText",
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              color: selected ? palette.textInverse : palette.textPrimary)),
                    ],
                  ),
                ));
          }),
    );
  }
}
