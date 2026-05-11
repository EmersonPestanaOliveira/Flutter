import 'attachment_storage_base.dart';
import 'local_payload_crypto.dart';

class PlainAttachmentStorage implements AttachmentStorage {
  const PlainAttachmentStorage(String baseDir);

  @override
  Future<String> persist(String sourcePath, String clientId, String subfolder) async {
    return sourcePath;
  }

  @override
  Future<String> prepareForUpload(String storedPath) async => storedPath;

  @override
  Future<void> cleanup(String clientId) async {}

  @override
  Future<bool> exists(String clientId) async => false;
}

class EncryptedAttachmentStorage implements AttachmentStorage {
  EncryptedAttachmentStorage(String baseDir, LocalCryptoKeyStore keyStore);

  @override
  Future<String> persist(String sourcePath, String clientId, String subfolder) async {
    return sourcePath;
  }

  @override
  Future<String> prepareForUpload(String storedPath) async => storedPath;

  @override
  Future<void> cleanup(String clientId) async {}

  @override
  Future<bool> exists(String clientId) async => false;
}
