import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/security/local_payload_crypto.dart';

void main() {
  test('AES-GCM encrypts and decrypts local payloads', () async {
    final crypto = AesGcmLocalPayloadCrypto(
      InMemoryLocalCryptoKeyStore(
        Uint8List.fromList(List<int>.generate(32, (index) => index)),
      ),
    );

    const payload = '{"clientId":"c1","latitude":-23.5}';
    final encrypted = await crypto.encrypt(payload);
    final decrypted = await crypto.decrypt(encrypted);

    expect(encrypted, isNot(payload));
    expect(encrypted, startsWith('v1.aesgcm.'));
    expect(decrypted, payload);
  });

  test('AES-GCM rejects tampered payloads', () async {
    final crypto = AesGcmLocalPayloadCrypto(InMemoryLocalCryptoKeyStore());
    final encrypted = await crypto.encrypt('{"ok":true}');
    final raw = base64Decode(encrypted.substring('v1.aesgcm.'.length));
    raw[raw.length - 1] = raw.last ^ 1;

    expect(
      () => crypto.decrypt('v1.aesgcm.${base64Encode(raw)}'),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });
}
