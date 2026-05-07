import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction for encrypting JSON payloads stored in the local SQLite outbox.
abstract interface class LocalPayloadCrypto {
  Future<String> encrypt(String plainJson);
  Future<String> decrypt(String cipherText);
}

abstract interface class LocalCryptoKeyStore {
  Future<Uint8List> getOrCreateKey();
}

class SecureStorageLocalCryptoKeyStore implements LocalCryptoKeyStore {
  const SecureStorageLocalCryptoKeyStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    String keyName = 'gabriel_occurrence_payload_aes256',
  })  : _storage = storage,
        _keyName = keyName;

  final FlutterSecureStorage _storage;
  final String _keyName;

  @override
  Future<Uint8List> getOrCreateKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null) {
      return Uint8List.fromList(base64Decode(existing));
    }

    final random = Random.secure();
    final key = Uint8List.fromList(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    await _storage.write(key: _keyName, value: base64Encode(key));
    return key;
  }
}

class InMemoryLocalCryptoKeyStore implements LocalCryptoKeyStore {
  InMemoryLocalCryptoKeyStore([Uint8List? key])
      : _key = key ??
            Uint8List.fromList(List<int>.generate(32, (index) => index + 1));

  final Uint8List _key;

  @override
  Future<Uint8List> getOrCreateKey() async => _key;
}

class AesGcmLocalPayloadCrypto implements LocalPayloadCrypto {
  AesGcmLocalPayloadCrypto(this._keyStore);

  static const _prefix = 'v1.aesgcm.';
  static const _nonceLength = 12;
  static const _macLength = 16;

  final LocalCryptoKeyStore _keyStore;
  final AesGcm _algorithm = AesGcm.with256bits();

  @override
  Future<String> encrypt(String plainJson) async {
    final key = await _keyStore.getOrCreateKey();
    final box = await _algorithm.encryptString(
      plainJson,
      secretKey: SecretKey(key),
    );
    final bytes = <int>[
      ...box.nonce,
      ...box.cipherText,
      ...box.mac.bytes,
    ];
    return '$_prefix${base64Encode(bytes)}';
  }

  @override
  Future<String> decrypt(String cipherText) async {
    if (!cipherText.startsWith(_prefix)) {
      // Compatibility for already queued rows created before encryption.
      return cipherText;
    }

    final key = await _keyStore.getOrCreateKey();
    final bytes = base64Decode(cipherText.substring(_prefix.length));
    if (bytes.length <= _nonceLength + _macLength) {
      throw const FormatException('Invalid encrypted payload.');
    }

    final nonce = bytes.sublist(0, _nonceLength);
    final mac = bytes.sublist(bytes.length - _macLength);
    final encrypted = bytes.sublist(_nonceLength, bytes.length - _macLength);
    return _algorithm.decryptString(
      SecretBox(encrypted, nonce: nonce, mac: Mac(mac)),
      secretKey: SecretKey(key),
    );
  }
}
