import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/Projects/project_badge.dart';

class ProjectDetailAppBar extends StatelessWidget {
  final String color;
  final String projectName;
  final VoidCallback? iconTapped;
  final String category;

  const ProjectDetailAppBar(
      {Key? key,
      required this.color,
      required this.projectName,
      required this.category,
      this.iconTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ColouredProjectBadge(color: color, category: category),
              AppSpaces.horizontalSpace20,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(projectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                        color: context.palette.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Text(category,
                    style: GoogleFonts.lato(color: context.palette.textMuted)),
              ])
            ],
          ),
          Row(children: [
            Icon(FeatherIcons.star, color: context.palette.textPrimary, size: 30),
            AppSpaces.horizontalSpace20,
            InkWell(
                onTap: iconTapped,
                child: Icon(Icons.more_horiz, color: context.palette.textPrimary, size: 30))
          ])
        ]);
  }
}
