import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Screens/Camera/camera_capture_screen.dart';

class AttachmentStore {
  AttachmentStore._();
  static final AttachmentStore instance = AttachmentStore._();

  final ImagePicker _picker = ImagePicker();

  Future<Attachment?> pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<Attachment?> pickImageFromCamera() => _pickImage(ImageSource.camera);

  Future<Attachment?> captureFromCamera(BuildContext context) async {
    final result = await Navigator.of(context).push<CapturedMedia>(
      MaterialPageRoute(
        builder: (_) => const CameraCaptureScreen(),
        fullscreenDialog: true,
      ),
    );
    if (result == null) return null;
    return _persistCapturedMedia(result);
  }

  Future<Attachment?> pickVideoFromGallery() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return null;
    return _persistFile(
      sourcePath: picked.path,
      originalName: picked.name,
      kind: AttachmentKind.video,
    );
  }

  Future<Attachment?> pickAnyFile() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    final path = file.path;
    if (path == null) return null;
    final lowered = file.name.toLowerCase();
    final isImage = lowered.endsWith('.png') ||
        lowered.endsWith('.jpg') ||
        lowered.endsWith('.jpeg') ||
        lowered.endsWith('.gif') ||
        lowered.endsWith('.webp');
    final isVideo = lowered.endsWith('.mp4') ||
        lowered.endsWith('.mov') ||
        lowered.endsWith('.m4v') ||
        lowered.endsWith('.avi');
    return _persistFile(
      sourcePath: path,
      originalName: file.name,
      kind: isImage
          ? AttachmentKind.image
          : isVideo
              ? AttachmentKind.video
              : AttachmentKind.doc,
    );
  }

  Future<Attachment?> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 82,
    );
    if (picked == null) return null;
    return _persistFile(
      sourcePath: picked.path,
      originalName: picked.name,
      kind: AttachmentKind.image,
    );
  }

  Future<Attachment?> _persistCapturedMedia(CapturedMedia media) {
    return _persistFile(
      sourcePath: media.path,
      originalName: media.originalName,
      kind: media.kind == CapturedMediaKind.video
          ? AttachmentKind.video
          : AttachmentKind.image,
    );
  }

  Future<Attachment> _persistFile({
    required String sourcePath,
    required String? originalName,
    required AttachmentKind kind,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final separator = Platform.pathSeparator;
    final attachmentsDir =
        Directory('${directory.path}${separator}attachments');
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    final extension =
        _extensionFor(originalName ?? sourcePath, defaultFor: kind);
    final fileName = '${DateTime.now().microsecondsSinceEpoch}$extension';
    final targetPath = '${attachmentsDir.path}$separator$fileName';
    final saved = await File(sourcePath).copy(targetPath);
    final bytes = await saved.length();

    final resolvedName = (originalName == null || originalName.isEmpty)
        ? fileName
        : originalName;

    return Attachment(
      name: resolvedName,
      sizeLabel: _formatBytes(bytes),
      kind: kind,
      localPath: saved.path,
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  String _extensionFor(String path, {required AttachmentKind defaultFor}) {
    final lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    final fileName =
        lastSeparator == -1 ? path : path.substring(lastSeparator + 1);
    final dot = fileName.lastIndexOf('.');
    if (dot != -1) return fileName.substring(dot);
    switch (defaultFor) {
      case AttachmentKind.video:
        return '.mp4';
      case AttachmentKind.image:
        return '.jpg';
      case AttachmentKind.doc:
        return '';
    }
  }
}
