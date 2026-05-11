import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';

class BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final int itemIndex;
  final ValueNotifier<int> notifier;

  BottomNavigationItem(
      {Key? key,
      required this.itemIndex,
      required this.notifier,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return InkWell(
      onTap: () => notifier.value = itemIndex,
      borderRadius: BorderRadius.circular(24),
      child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (BuildContext context, _, __) {
            final isSelected = notifier.value == itemIndex;
            final iconColor = isLight
                ? Colors.white
                    .withValues(alpha: isSelected ? 1.0 : 0.7)
                : (isSelected
                    ? context.palette.accent
                    : Colors.white.withValues(alpha: 0.55));
            final highlight = isLight && isSelected
                ? BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  )
                : null;
            return Container(
              decoration: highlight,
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 24, color: iconColor),
            );
          }),
    );
  }
}
