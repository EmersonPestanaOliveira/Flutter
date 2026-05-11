import 'package:firebase_storage/firebase_storage.dart';

Future<int> localFileLength(String path) async => 0;

Future<String> uploadLocalFile(Reference reference, String path) {
  throw UnsupportedError(
    'Upload de arquivo local por path nao e suportado no Web.',
  );
}

Future<void> deleteLocalFileIfExists(String path) async {}
