import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlacasInfoSection {
  const PlacasInfoSection({required this.title, required this.body});

  final String title;
  final String body;
}

class PlacasSolicitacaoInput {
  const PlacasSolicitacaoInput({
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.telefone,
    required this.perfilContato,
    required this.cep,
    required this.endereco,
    required this.numeroEndereco,
    required this.jaFazParteLocalidade,
    required this.melhorHorarioContato,
  });

  final String nome;
  final String sobrenome;
  final String email;
  final String telefone;
  final String perfilContato;
  final String cep;
  final String endereco;
  final String numeroEndereco;
  final String jaFazParteLocalidade;
  final String melhorHorarioContato;
}

class PlacasService {
  PlacasService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<List<PlacasInfoSection>> fetchInfoSections() async {
    final snapshot = await _firestore
        .collection('placas_info')
        .orderBy('ordem')
        .get();

    if (snapshot.docs.isEmpty) {
      return _fallbackInfo;
    }

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return PlacasInfoSection(
            title: data['titulo'] as String? ?? '',
            body: data['descricao'] as String? ?? '',
          );
        })
        .where((section) => section.title.isNotEmpty || section.body.isNotEmpty)
        .toList();
  }

  Future<String> createSolicitacao(PlacasSolicitacaoInput input) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuario nao autenticado.');
    }

    final doc = _firestore.collection('placas_solicitacoes').doc();
    await doc.set({
      'userId': user.uid,
      'userEmail': user.email,
      'nome': input.nome,
      'sobrenome': input.sobrenome,
      'email': input.email,
      'telefone': input.telefone,
      'perfilContato': input.perfilContato,
      'cep': input.cep,
      'endereco': input.endereco,
      'numeroEndereco': input.numeroEndereco,
      'jaFazParteLocalidade': input.jaFazParteLocalidade,
      'melhorHorarioContato': input.melhorHorarioContato,
      'status': 'novo',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  static const _fallbackInfo = [
    PlacasInfoSection(
      title: 'O que é essa funcionalidade?',
      body:
          'Um recurso que busca identificar seu veículo furtado ou roubado através da leitura realizada pelos nossos Camaleões.',
    ),
    PlacasInfoSection(
      title: 'Como a Gabriel pode ajudar a recuperar meu veículo?',
      body:
          'Ao cadastrar a placa em nosso App, os Camaleões buscarão o veículo por 60 dias. Se o veículo for detectado na nossa Área de Proteção, durante esse período, você e as autoridades serão imediatamente notificados. Além disso, nosso Time de Inteligência irá buscar informações relevantes e imagens que auxiliem as autoridades na investigação.',
    ),
    PlacasInfoSection(
      title: 'Quando devo adicionar uma placa?',
      body:
          'Somente em caso de roubo ou furto do veículo, sempre acompanhado de seu Boletim de Ocorrência.',
    ),
    PlacasInfoSection(
      title: 'Preciso registrar na polícia também?',
      body:
          'Sim, o cadastro da sua placa no App da Gabriel só poderá ser realizado mediante a apresentação de um Boletim de Ocorrência. Este documento é necessário para que a autoridade policial realize a investigação.',
    ),
  ];
}
