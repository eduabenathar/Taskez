import 'dart:io';

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
    final path = attachment.localPath;
    final file = path == null ? null : File(path);
    final fileExists = file != null && file.existsSync();

    if (attachment.kind == AttachmentKind.image && fileExists) {
      return Image.file(file, fit: BoxFit.cover);
    }

    if (attachment.kind == AttachmentKind.video) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: fallbackColor.withValues(alpha: 0.85)),
          const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      );
    }

    return ColoredBox(
      color: fallbackColor,
      child: Icon(fallbackIcon, color: Colors.white, size: 26),
    );
  }
}
