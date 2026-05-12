import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

    final directory = await getApplicationDocumentsDirectory();
    final separator = Platform.pathSeparator;
    final attachmentsDir =
        Directory('${directory.path}${separator}attachments');
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    final extension = _extensionFor(picked.path);
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}${extension.isEmpty ? '.jpg' : extension}';
    final targetPath = '${attachmentsDir.path}$separator$fileName';
    final saved = await File(picked.path).copy(targetPath);
    final bytes = await saved.length();

    return Attachment(
      name: picked.name.isEmpty ? fileName : picked.name,
      sizeLabel: _formatBytes(bytes),
      kind: AttachmentKind.image,
      localPath: saved.path,
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  String _extensionFor(String path) {
    final lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    final fileName =
        lastSeparator == -1 ? path : path.substring(lastSeparator + 1);
    final dot = fileName.lastIndexOf('.');
    return dot == -1 ? '' : fileName.substring(dot);
  }
}
