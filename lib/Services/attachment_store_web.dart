import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskez/Data/data_model.dart';

class AttachmentStore {
  AttachmentStore._();
  static final AttachmentStore instance = AttachmentStore._();

  final ImagePicker _picker = ImagePicker();

  Future<Attachment?> pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<Attachment?> pickImageFromCamera() => _pickImage(ImageSource.camera);

  Future<Attachment?> captureFromCamera(BuildContext context) =>
      _pickImage(ImageSource.camera);

  Future<Attachment?> pickVideoFromGallery() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    final mimeType = picked.mimeType ?? 'video/mp4';
    return Attachment(
      name: picked.name.isEmpty ? 'video.mp4' : picked.name,
      sizeLabel: _formatBytes(bytes.length),
      kind: AttachmentKind.video,
      localPath: 'data:$mimeType;base64,${base64Encode(bytes)}',
    );
  }

  Future<Attachment?> pickAnyFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return null;
    final lowered = file.name.toLowerCase();
    final isImage = lowered.endsWith('.png') ||
        lowered.endsWith('.jpg') ||
        lowered.endsWith('.jpeg') ||
        lowered.endsWith('.gif') ||
        lowered.endsWith('.webp');
    final isVideo = lowered.endsWith('.mp4') ||
        lowered.endsWith('.mov') ||
        lowered.endsWith('.m4v');
    final mimeType = isImage
        ? 'image/${lowered.split('.').last}'
        : isVideo
            ? 'video/mp4'
            : 'application/octet-stream';
    return Attachment(
      name: file.name,
      sizeLabel: _formatBytes(bytes.length),
      kind: isImage
          ? AttachmentKind.image
          : isVideo
              ? AttachmentKind.video
              : AttachmentKind.doc,
      localPath: 'data:$mimeType;base64,${base64Encode(bytes)}',
    );
  }

  Future<Attachment?> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 82,
    );
    if (picked == null) return null;

    final bytes = await picked.readAsBytes();
    final mimeType = picked.mimeType ?? 'image/jpeg';

    return Attachment(
      name: picked.name.isEmpty ? 'image.jpg' : picked.name,
      sizeLabel: _formatBytes(bytes.length),
      kind: AttachmentKind.image,
      localPath: 'data:$mimeType;base64,${base64Encode(bytes)}',
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }
}
