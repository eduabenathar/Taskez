part of values;

class BoxDecorationStyles {
  static BoxDecoration fadingGlory(BuildContext context) {
    final palette = context.palette;
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.surfaceElevated,
            palette.surface,
            palette.background,
            palette.background,
          ]),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    );
  }

  static BoxDecoration fadingInnerDecor(BuildContext context) =>
      BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(20));
}
