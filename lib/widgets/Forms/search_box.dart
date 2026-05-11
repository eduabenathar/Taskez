// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';

class SearchBox extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  const SearchBox({
    Key? key,
    required this.placeholder,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextFormField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 20, color: palette.textPrimary),
      onTap: () {},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(FeatherIcons.search, color: palette.iconPrimary),
        ),
        suffixIcon: InkWell(
          onTap: () { controller!.text = ""; },
          child: Icon(FontAwesomeIcons.solidTimesCircle,
              color: palette.textSecondary, size: 20),
        ),
        hintText: placeholder,
        hintStyle: GoogleFonts.lato(fontSize: 18, color: palette.textMuted),
        filled: true,
        fillColor: palette.surface,
      ),
    );
  }
}
