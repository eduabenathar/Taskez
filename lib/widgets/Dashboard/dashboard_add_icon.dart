import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';

class DashboardAddButton extends StatelessWidget {
  final VoidCallback? iconTapped;
  const DashboardAddButton({
    Key? key,
    this.iconTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return InkWell(
      onTap: iconTapped,
      borderRadius: BorderRadius.circular(isLight ? 14 : 25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isLight ? Colors.white : context.palette.accent,
          shape: isLight ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: isLight ? BorderRadius.circular(14) : null,
        ),
        child: Icon(
          Icons.add,
          color: isLight
              ? const Color(0xFF5B5BF0)
              : context.palette.textInverse,
        ),
      ),
    );
  }
}
