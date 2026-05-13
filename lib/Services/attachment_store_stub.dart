import 'package:flutter/widgets.dart';
import 'package:taskez/Data/data_model.dart';

class AttachmentStore {
  AttachmentStore._();
  static final AttachmentStore instance = AttachmentStore._();

  Future<Attachment?> pickImageFromGallery() async => null;

  Future<Attachment?> pickImageFromCamera() async => null;

  Future<Attachment?> captureFromCamera(BuildContext context) async => null;

  Future<Attachment?> pickVideoFromGallery() async => null;

  Future<Attachment?> pickAnyFile() async => null;
}
