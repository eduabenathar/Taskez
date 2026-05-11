import 'package:flutter/material.dart';
import 'package:flutter_shapes/flutter_shapes.dart';

class BackgroundHexagon extends CustomPainter {
  final Color color;
  BackgroundHexagon({this.color = const Color(0xFF262A34)});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Shapes shapes = Shapes(
        canvas: canvas,
        radius: 50,
        paint: paint,
        center: Offset.zero,
        angle: 0);

    shapes.drawType(ShapeType.Hexagon); // enum
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
