import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:taskez/Data/data_model.dart';

class AttachmentStore {
  AttachmentStore._();
  static final AttachmentStore instance = AttachmentStore._();

  final ImagePicker _picker = ImagePicker();

  Future<Attachment?> pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<Attachment?> pickImageFromCamera() => _pickImage(ImageSource.camera);

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
