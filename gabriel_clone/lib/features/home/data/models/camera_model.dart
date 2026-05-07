import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/camera.dart';

class CameraModel extends Camera {
  const CameraModel({
    required super.id,
    required super.nome,
    required super.latitude,
    required super.longitude,
    required super.ativo,
    super.rua,
    super.bairro,
    super.cidade,
    super.regiao,
    super.linkAoVivo,
    super.users,
    super.cep,
    super.numero,
  });

  factory CameraModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final location = data['localizacao'];

    return CameraModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      latitude: location is GeoPoint ? location.latitude : 0,
      longitude: location is GeoPoint ? location.longitude : 0,
      ativo: data['ativo'] as bool? ?? true,
      rua:
          data['rua'] as String? ??
          data['logradouro'] as String? ??
          data['endereco'] as String? ??
          '',
      bairro: data['bairro'] as String? ?? '',
      cidade: data['cidade'] as String? ?? '',
      regiao: data['regiao'] as String? ?? '',
      linkAoVivo:
          data['linkAoVivo'] as String? ??
          data['link_ao_vivo'] as String? ??
          data['streamUrl'] as String? ??
          '',
      users: _readUsers(data['users']),
      cep: data['cep'] as String? ?? '',
      numero: data['numero'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'localizacao': GeoPoint(latitude, longitude),
      'ativo': ativo,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'regiao': regiao,
      'linkAoVivo': linkAoVivo,
      'users': users,
      'cep': cep,
      'numero': numero,
    };
  }

  static List<String> _readUsers(Object? value) {
    if (value is Iterable) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }
}
