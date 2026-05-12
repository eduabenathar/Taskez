export 'attachment_store_stub.dart'
    if (dart.library.io) 'attachment_store_io.dart'
    if (dart.library.html) 'attachment_store_web.dart';
