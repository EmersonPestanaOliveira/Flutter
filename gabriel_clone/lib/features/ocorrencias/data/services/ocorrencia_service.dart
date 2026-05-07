import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OcorrenciaInfoSection {
  const OcorrenciaInfoSection({required this.title, required this.body});

  final String title;
  final String body;
}

class OcorrenciaAttachment {
  const OcorrenciaAttachment({
    required this.path,
    required this.storageName,
    required this.kind,
  });

  final String path;
  final String storageName;
  final String kind;
}

class CreateOcorrenciaInput {
  const CreateOcorrenciaInput({
    required this.informacoes,
    required this.quando,
    required this.horario,
    required this.latitude,
    required this.longitude,
    required this.enderecoBusca,
    required this.cienteBoletim,
    required this.aceitePrivacidade,
    this.audio,
    this.boletimOcorrencia,
    this.multimidia = const [],
  });

  final String informacoes;
  final DateTime quando;
  final String horario;
  final double latitude;
  final double longitude;
  final String enderecoBusca;
  final bool cienteBoletim;
  final bool aceitePrivacidade;
  final OcorrenciaAttachment? audio;
  final OcorrenciaAttachment? boletimOcorrencia;
  final List<OcorrenciaAttachment> multimidia;
}

class OcorrenciaService {
  OcorrenciaService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  Future<List<OcorrenciaInfoSection>> fetchInfoSections() async {
    final snapshot = await _firestore
        .collection('ocorrencias_info')
        .orderBy('ordem')
        .get();

    if (snapshot.docs.isEmpty) {
      return _fallbackInfo;
    }

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return OcorrenciaInfoSection(
            title: data['titulo'] as String? ?? '',
            body: data['descricao'] as String? ?? '',
          );
        })
        .where((section) {
          return section.title.isNotEmpty || section.body.isNotEmpty;
        })
        .toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMyOcorrencias() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('ocorrencias')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }

  Future<String> createOcorrencia(CreateOcorrenciaInput input) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuario nao autenticado.');
    }

    final doc = _firestore.collection('ocorrencias').doc();
    final uploadBase = 'users/${user.uid}/ocorrencias/${doc.id}';

    final audioUrl = input.audio == null
        ? null
        : await _upload(input.audio!, '$uploadBase/audio');
    final boletimUrl = input.boletimOcorrencia == null
        ? null
        : await _upload(input.boletimOcorrencia!, '$uploadBase/boletim');

    final mediaUrls = <Map<String, String>>[];
    for (final media in input.multimidia) {
      final url = await _upload(media, '$uploadBase/multimidia');
      mediaUrls.add({'url': url, 'tipo': media.kind});
    }

    await doc.set({
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
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  Future<String> _upload(OcorrenciaAttachment attachment, String folder) async {
    final reference = _storage.ref('$folder/${attachment.storageName}');
    final task = await reference.putFile(File(attachment.path));
    return task.ref.getDownloadURL();
  }

  static const _fallbackInfo = [
    OcorrenciaInfoSection(
      title: 'Quando devo relatar uma ocorrência?',
      body:
          'Você pode informar qualquer incidente que tenha presenciado ou sofrido na nossa Área de Proteção.',
    ),
    OcorrenciaInfoSection(
      title: 'Como a Gabriel atua na ocorrência?',
      body:
          'A partir das câmeras, a Central 24h é capaz de entender o antes, durante e depois do fato. Essa inteligência torna o trabalho da polícia mais rápido, eficiente e transparente.',
    ),
    OcorrenciaInfoSection(
      title:
          'Já fiz o relato para a Gabriel. Preciso registrar na polícia também?',
      body:
          'Sim, o relato no App da Gabriel não substitui o registro do Boletim de Ocorrência, documento necessário para que a autoridade policial realize a investigação.',
    ),
    OcorrenciaInfoSection(
      title: 'Fiz um relato, porém consta inválido. E agora?',
      body:
          'Você pode acompanhar o status do seu relato no aplicativo. Quando houver inconsistência, a Central 24h poderá entrar em contato para prestar suporte.',
    ),
  ];
}
