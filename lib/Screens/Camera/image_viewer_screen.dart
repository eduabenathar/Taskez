import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageViewerScreen extends StatelessWidget {
  final String source;
  final String? title;

  const ImageViewerScreen({
    Key? key,
    required this.source,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRemote = kIsWeb ||
        source.startsWith('http') ||
        source.startsWith('data:');
    final image = isRemote
        ? Image.network(source, fit: BoxFit.contain)
        : Image.file(File(source), fit: BoxFit.contain);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title ?? '',
          style: GoogleFonts.lato(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: image,
        ),
      ),
    );
  }
}
