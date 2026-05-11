import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<int> localFileLength(String path) async {
  final file = File(path);
  if (!await file.exists()) return 0;
  return file.length();
}

Future<String> uploadLocalFile(Reference reference, String path) async {
  final task = await reference.putFile(File(path));
  return task.ref.getDownloadURL();
}

Future<void> deleteLocalFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
