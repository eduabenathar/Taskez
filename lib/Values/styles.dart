part of values;

class AppTextStyles {
  static TextStyle bottomLink(BuildContext context) => GoogleFonts.lato(
      color: context.palette.textPrimary,
      fontSize: 25,
      fontWeight: FontWeight.w600);

  static final TextStyle flyInTextStyle = GoogleFonts.lato(
      color: Color.fromRGBO(154, 116, 84, 0.5),
      fontSize: 100,
      fontWeight: FontWeight.w300);

  static TextStyle headerTextStyle(BuildContext context) => GoogleFonts.lato(
      color: context.palette.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w600);

  static final TextStyle brandTextStyle =
      GoogleFonts.lato(fontSize: 35, fontWeight: FontWeight.bold);

  static TextStyle header2(BuildContext context) => GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: context.palette.textPrimary);
}
