import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;

import 'attachment_storage_base.dart';
import 'local_payload_crypto.dart';

class PlainAttachmentStorage implements AttachmentStorage {
  const PlainAttachmentStorage(this._baseDir);

  final String _baseDir;

  @override
  Future<String> persist(
    String sourcePath,
    String clientId,
    String subfolder,
  ) async {
    final attachDir = Directory(p.join(_baseDir, 'ocorrencias', clientId, subfolder));
    await attachDir.create(recursive: true);

    final src = File(sourcePath);
    final destPath = p.join(attachDir.path, p.basename(sourcePath));
    if (p.normalize(src.path) == p.normalize(destPath)) return sourcePath;
    return (await src.copy(destPath)).path;
  }

  @override
  Future<String> prepareForUpload(String storedPath) async => storedPath;

  @override
  Future<void> cleanup(String clientId) async {
    final dir = Directory(p.join(_baseDir, 'ocorrencias', clientId));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  @override
  Future<bool> exists(String clientId) {
    return Directory(p.join(_baseDir, 'ocorrencias', clientId)).exists();
  }
}

class EncryptedAttachmentStorage implements AttachmentStorage {
  EncryptedAttachmentStorage(this._baseDir, this._keyStore);

  static const _prefix = 'v1.aesgcm.file.';
  static const _nonceLength = 12;
  static const _macLength = 16;

  final String _baseDir;
  final LocalCryptoKeyStore _keyStore;
  final AesGcm _algorithm = AesGcm.with256bits();

  @override
  Future<String> persist(
    String sourcePath,
    String clientId,
    String subfolder,
  ) async {
    final attachDir = Directory(p.join(_baseDir, 'ocorrencias', clientId, subfolder));
    await attachDir.create(recursive: true);

    final src = File(sourcePath);
    final fileName = '${p.basename(sourcePath)}.enc';
    final destPath = p.join(attachDir.path, fileName);
    if (p.normalize(src.path) == p.normalize(destPath)) return sourcePath;

    final clearBytes = await src.readAsBytes();
    final box = await _algorithm.encrypt(
      clearBytes,
      secretKey: SecretKey(await _keyStore.getOrCreateKey()),
    );
    final envelope = <int>[
      ...utf8.encode(_prefix),
      ...box.nonce,
      ...box.cipherText,
      ...box.mac.bytes,
    ];
    await File(destPath).writeAsBytes(envelope, flush: true);
    return destPath;
  }

  @override
  Future<String> prepareForUpload(String storedPath) async {
    if (!storedPath.endsWith('.enc')) return storedPath;

    final bytes = await File(storedPath).readAsBytes();
    final marker = utf8.encode(_prefix);
    final hasMarker = bytes.length > marker.length &&
        List<int>.generate(marker.length, (index) => index)
            .every((index) => bytes[index] == marker[index]);
    if (!hasMarker) return storedPath;

    final offset = marker.length;
    final nonce = bytes.sublist(offset, offset + _nonceLength);
    final mac = bytes.sublist(bytes.length - _macLength);
    final encrypted = bytes.sublist(offset + _nonceLength, bytes.length - _macLength);
    final clear = await _algorithm.decrypt(
      SecretBox(encrypted, nonce: nonce, mac: Mac(mac)),
      secretKey: SecretKey(await _keyStore.getOrCreateKey()),
    );

    final uploadDir = Directory(p.join(_baseDir, 'ocorrencias_upload_tmp'));
    await uploadDir.create(recursive: true);
    final uploadPath = p.join(
      uploadDir.path,
      p.basenameWithoutExtension(storedPath),
    );
    await File(uploadPath).writeAsBytes(clear, flush: true);
    return uploadPath;
  }

  @override
  Future<void> cleanup(String clientId) async {
    final dir = Directory(p.join(_baseDir, 'ocorrencias', clientId));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  @override
  Future<bool> exists(String clientId) {
    return Directory(p.join(_baseDir, 'ocorrencias', clientId)).exists();
  }
}
