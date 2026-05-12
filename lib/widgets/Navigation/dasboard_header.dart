import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Screens/Dashboard/search_screen.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/dummy/profile_dummy.dart';

class DashboardNav extends StatelessWidget {
  final String title;
  final String image;
  final IconData icon;
  final StatelessWidget? page;
  final VoidCallback? onImageTapped;
  final String notificationCount;

  DashboardNav(
      {Key? key,
      required this.title,
      required this.icon,
      required this.image,
      required this.notificationCount,
      this.page,
      this.onImageTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(this.title, style: AppTextStyles.header2(context)),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkWell(
          onTap: () {
            if (page != null) Get.to(() => page!);
          },
          child: Stack(clipBehavior: Clip.none, children: <Widget>[
            Icon(icon, color: context.palette.iconPrimary, size: 30),
            Positioned(
              top: -6.0,
              right: -8.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(shape: BoxShape.circle, color: HexColor.fromHex("FF9B76")),
                alignment: Alignment.center,
                child: Text(notificationCount, style: GoogleFonts.lato(fontSize: 11, color: context.palette.textPrimary)),
              ),
            )
          ]),
        ),
        SizedBox(width: 28),
        InkWell(
          onTap: () => Get.to(() => Scaffold(
                backgroundColor: context.palette.surface,
                body: SearchScreen(),
              )),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(FeatherIcons.search, color: context.palette.iconPrimary, size: 28),
          ),
        ),
        SizedBox(width: 28),
        InkWell(
          onTap: onImageTapped,
          child: ProfileDummy(
              color: HexColor.fromHex("93F0F0"), dummyType: ProfileDummyType.Image, image: this.image, scale: 1.2),
        )
      ])
    ]);
  }
}
