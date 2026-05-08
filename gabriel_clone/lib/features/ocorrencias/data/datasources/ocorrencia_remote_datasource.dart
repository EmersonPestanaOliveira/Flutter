import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/geo/geo_utils.dart';
import '../../../../core/observability/telemetry.dart';
import '../../../../core/security/attachment_storage.dart';
import '../../data/services/ocorrencia_service.dart';

/// Responsabilidade exclusiva: fazer upload de attachments e gravar no Firestore.
/// Não sabe nada sobre filas, retries ou status offline.
abstract interface class OcorrenciaRemoteDatasource {
  /// Cria uma ocorrência no Firestore usando [clientId] como ID do documento
  /// (idempotência: segunda chamada com mesmo ID faz upsert sem duplicar).
  Future<void> createOcorrencia({
    required String clientId,
    required CreateOcorrenciaInput input,
  });
}

class OcorrenciaRemoteDatasourceImpl implements OcorrenciaRemoteDatasource {
  OcorrenciaRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
    required AttachmentStorage attachmentStorage,
    Telemetry? telemetry,
  }) : _firestore = firestore,
       _auth = auth,
       _storage = storage,
       _attachmentStorage = attachmentStorage,
       _telemetry = telemetry;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final AttachmentStorage _attachmentStorage;
  final Telemetry? _telemetry;

  @override
  Future<void> createOcorrencia({
    required String clientId,
    required CreateOcorrenciaInput input,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuario nao autenticado.');
    }

    final uploadBase = 'users/${user.uid}/ocorrencias/$clientId';

    final attachmentCount = input.multimidia.length +
        (input.audio == null ? 0 : 1) +
        (input.boletimOcorrencia == null ? 0 : 1);
    final totalAttachmentBytes = await _totalAttachmentBytes(input);
    _telemetry?.log('sync.attachments_upload_started', params: {
      'clientId': _safeId(clientId),
      'attachmentCount': attachmentCount,
      'totalSizeBytes': totalAttachmentBytes,
    });

    final audioUrl = input.audio == null
        ? null
        : await _upload(input.audio!, '$uploadBase/audio', clientId);
    final boletimUrl = input.boletimOcorrencia == null
        ? null
        : await _upload(input.boletimOcorrencia!, '$uploadBase/boletim', clientId);

    final mediaUrls = <Map<String, String>>[];
    for (final media in input.multimidia) {
      final url = await _upload(media, '$uploadBase/multimidia', clientId);
      mediaUrls.add({'url': url, 'tipo': media.kind});
    }

    final doc = _firestore.collection('ocorrencias').doc(clientId);
    final existing = await doc.get();
    final payload = <String, Object?>{
      'clientId': clientId,
      'userId': user.uid,
      'userEmail': user.email,
      'informacoes': input.informacoes,
      'quando': Timestamp.fromDate(input.quando),
      'horario': input.horario,
      'latitude': input.latitude,
      'longitude': input.longitude,
      'enderecoBusca': input.enderecoBusca,
      'audio': audioUrl,
      'boletimOcorrencia': boletimUrl,
      'multimidia': mediaUrls,
      'cienteBoletim': input.cienteBoletim,
      'aceitePrivacidade': input.aceitePrivacidade,
      'status': 'em_andamento',
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (!existing.exists) {
      payload['createdAt'] = FieldValue.serverTimestamp();
    }

    // Usa clientId como ID do documento: retry faz upsert sem duplicar.
    await doc.set(payload, SetOptions(merge: true));

    await _firestore.collection('alertas').doc(clientId).set(
      {
        'clientId': clientId,
        'source': 'ocorrencia',
        'bairro': '',
        'cidade': '',
        'data': Timestamp.fromDate(input.quando),
        'descricao': 'Relato comunitario',
        'tipo': 'Outros',
        'localizacao': GeoPoint(input.latitude, input.longitude),
        'geohash': GeoUtils.geohash(input.latitude, input.longitude),
        'updatedAt': FieldValue.serverTimestamp(),
        if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<String> _upload(
    OcorrenciaAttachment attachment,
    String folder,
    String clientId,
  ) async {
    final start = DateTime.now().millisecondsSinceEpoch;
    final reference = _storage.ref('$folder/${attachment.storageName}');
    final uploadPath = await _attachmentStorage.prepareForUpload(attachment.path);
    final uploadFile = File(uploadPath);
    final sizeBytes = await uploadFile.length();
    try {
      final task = await reference.putFile(uploadFile);
      final url = await task.ref.getDownloadURL();
      _telemetry?.log('sync.attachment_upload_success', params: {
        'clientId': _safeId(clientId),
        'kind': attachment.kind,
        'sizeBytes': sizeBytes,
        'elapsedMs': DateTime.now().millisecondsSinceEpoch - start,
      });
      return url;
    } catch (e) {
      _telemetry?.log('sync.attachment_upload_failed', params: {
        'clientId': _safeId(clientId),
        'kind': attachment.kind,
        'sizeBytes': sizeBytes,
        'elapsedMs': DateTime.now().millisecondsSinceEpoch - start,
        'errorType': e.runtimeType.toString(),
      });
      rethrow;
    } finally {
      if (uploadPath != attachment.path) {
        final temp = File(uploadPath);
        if (await temp.exists()) {
          await temp.delete();
        }
      }
    }
  }

  String _safeId(String clientId) =>
      clientId.length > 8 ? clientId.substring(0, 8) : clientId;

  Future<int> _totalAttachmentBytes(CreateOcorrenciaInput input) async {
    final paths = <String>[
      if (input.audio != null) input.audio!.path,
      if (input.boletimOcorrencia != null) input.boletimOcorrencia!.path,
      ...input.multimidia.map((attachment) => attachment.path),
    ];
    var total = 0;
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) {
        total += await file.length();
      }
    }
    return total;
  }
}
