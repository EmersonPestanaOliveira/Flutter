abstract interface class AttachmentStorage {
  Future<String> persist(String sourcePath, String clientId, String subfolder);
  Future<String> prepareForUpload(String storedPath);
  Future<void> cleanup(String clientId);
  Future<bool> exists(String clientId);
}
