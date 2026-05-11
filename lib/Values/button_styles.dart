part of values;

class ButtonStyles {
  static ButtonStyle blueRounded(BuildContext context) {
    final accent = context.palette.accent;
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(accent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: accent))));
  }

  static ButtonStyle imageRounded(BuildContext context) {
    final palette = context.palette;
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(palette.surface),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: palette.divider, width: 1))));
  }
}
