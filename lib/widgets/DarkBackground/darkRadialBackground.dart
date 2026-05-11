import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';

// ignore: must_be_immutable
class DarkRadialBackground extends StatelessWidget {
  final String position;
  final Color? color;
  DarkRadialBackground({this.color, required this.position});

  static const Color _lightLavenderInner = Color(0xFFE5E0F5);
  static const Color _lightLavenderMid = Color(0xFFEEEAF8);
  static const Color _lightLavenderOuter = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final List<Color> colors;
    if (isLight) {
      colors = const [
        _lightLavenderInner,
        _lightLavenderMid,
        _lightLavenderMid,
        _lightLavenderOuter,
      ];
    } else {
      final innerColor = color ?? palette.surface;
      colors = [
        palette.surfaceElevated,
        palette.surface,
        palette.surface,
        innerColor,
      ];
    }

    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: colors,
            stops: isLight ? const [0.0, 0.18, 0.33, 1.0] : null,
            radius: isLight ? 1.6 : 1.2,
            center: (position == "bottomRight")
                ? Alignment(1.0, 1.0)
                : Alignment(-1.0, -1.0),
          ),
        ),
      ),
    );
  }
}
