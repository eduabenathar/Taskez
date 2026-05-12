import 'package:taskez/Data/data_model.dart';

class AttachmentStore {
  AttachmentStore._();
  static final AttachmentStore instance = AttachmentStore._();

  Future<Attachment?> pickImageFromGallery() async => null;

  Future<Attachment?> pickImageFromCamera() async => null;
}
