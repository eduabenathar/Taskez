import 'package:flutter/material.dart';
import 'package:taskez/Data/data_model.dart';

class AttachmentPreview extends StatelessWidget {
  final Attachment attachment;
  final Color fallbackColor;
  final IconData fallbackIcon;

  const AttachmentPreview({
    Key? key,
    required this.attachment,
    required this.fallbackColor,
    required this.fallbackIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: fallbackColor,
      child: Icon(fallbackIcon, color: Colors.white, size: 26),
    );
  }
}
