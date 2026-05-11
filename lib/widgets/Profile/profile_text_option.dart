import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

// ignore: must_be_immutable
class ProfileTextOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final double? margin;

  ProfileTextOption(
      {Key? key, required this.label, required this.icon, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: this.margin ?? 10.0),
            child: ListTile(
                title: Row(
                  children: [
                    Icon(icon, color: palette.iconPrimary, size: 24),
                    Text(label,
                        style: GoogleFonts.lato(
                            fontSize: 18, color: palette.textPrimary)),
                  ],
                ),
                trailing: SizedBox()),
          ),
          Divider(height: 1, color: palette.divider)
        ],
      ),
    );
  }
}
