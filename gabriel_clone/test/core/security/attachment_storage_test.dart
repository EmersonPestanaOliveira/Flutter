import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/security/attachment_storage.dart';
import 'package:gabriel_clone/core/security/local_payload_crypto.dart';

void main() {
  test('EncryptedAttachmentStorage stores encrypted file and materializes upload copy', () async {
    final dir = await Directory.systemTemp.createTemp('gabriel_attachment_test_');
    addTearDown(() => dir.delete(recursive: true));

    final source = File('${dir.path}/source.txt');
    await source.writeAsString('secret attachment');

    final storage = EncryptedAttachmentStorage(
      dir.path,
      InMemoryLocalCryptoKeyStore(),
    );

    final stored = await storage.persist(source.path, 'client-1', 'media');
    expect(stored.endsWith('.enc'), isTrue);
    expect(await File(stored).readAsBytes(), isNot(containsAll('secret attachment'.codeUnits)));

    final upload = await storage.prepareForUpload(stored);
    expect(await File(upload).readAsString(), 'secret attachment');
  });
}
