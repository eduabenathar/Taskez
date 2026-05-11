import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverviewStatCard extends StatelessWidget {
  final String title;
  final String count;
  final String label;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;

  const OverviewStatCard({
    Key? key,
    required this.title,
    required this.count,
    required this.label,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
  }) : super(key: key);

  static const double _cornerRadius = 28;
  static const double _biteSize = 44;
  static const double _biteRadius = 18;
  static const double _badgeSize = 36;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: _BittenCardClipper(
            cornerRadius: _cornerRadius,
            biteWidth: _biteSize,
            biteHeight: _biteSize,
            biteRadius: _biteRadius,
          ),
          child: Container(
            color: backgroundColor,
            padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: _biteSize + 4),
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      color: accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      count,
                      style: GoogleFonts.lato(
                        color: accentColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        label,
                        style: GoogleFonts.lato(
                          color: accentColor.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: _badgeSize,
            height: _badgeSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
        ),
      ],
    );
  }
}

/// Clips a rounded rectangle and removes a rectangular bite from the top-right
/// corner. The bite has three rounded corners: top-left of bite (convex),
/// inner L corner (concave), and bottom-right of bite (convex).
class _BittenCardClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double biteWidth;
  final double biteHeight;
  final double biteRadius;

  _BittenCardClipper({
    required this.cornerRadius,
    required this.biteWidth,
    required this.biteHeight,
    required this.biteRadius,
  });

  @override
  Path getClip(Size size) {
    final r = cornerRadius;
    final br = biteRadius;
    final bw = biteWidth;
    final bh = biteHeight;
    final w = size.width;
    final h = size.height;

    // Inner L vertex (without rounding) sits at (w - bw, bh).
    final biteLeftX = w - bw;
    final biteBottomY = bh;

    final path = Path()
      // Top edge starts after the top-left rounded corner.
      ..moveTo(r, 0)
      // Top edge goes right, stops before the top-left corner of the bite.
      ..lineTo(biteLeftX - br, 0)
      // Convex corner: top edge curves down into the bite.
      ..arcToPoint(
        Offset(biteLeftX, br),
        radius: Radius.circular(br),
      )
      // Down the bite's left edge to the inner L corner.
      ..lineTo(biteLeftX, biteBottomY - br)
      // Concave inner corner (clockwise:false so it bulges outward / into bite).
      ..arcToPoint(
        Offset(biteLeftX + br, biteBottomY),
        radius: Radius.circular(br),
        clockwise: false,
      )
      // Along the bite's bottom edge to the right side of the card.
      ..lineTo(w - br, biteBottomY)
      // Convex corner: bottom edge of bite curves down onto the card's right edge.
      ..arcToPoint(
        Offset(w, biteBottomY + br),
        radius: Radius.circular(br),
      )
      // Right edge down to bottom-right corner.
      ..lineTo(w, h - r)
      ..arcToPoint(
        Offset(w - r, h),
        radius: Radius.circular(r),
      )
      // Bottom edge.
      ..lineTo(r, h)
      ..arcToPoint(
        Offset(0, h - r),
        radius: Radius.circular(r),
      )
      // Left edge up.
      ..lineTo(0, r)
      ..arcToPoint(
        Offset(r, 0),
        radius: Radius.circular(r),
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _BittenCardClipper oldClipper) =>
      oldClipper.cornerRadius != cornerRadius ||
      oldClipper.biteWidth != biteWidth ||
      oldClipper.biteHeight != biteHeight ||
      oldClipper.biteRadius != biteRadius;
}
