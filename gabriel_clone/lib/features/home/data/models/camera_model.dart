import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/camera.dart';

class CameraModel extends Camera {
  const CameraModel({
    required super.id,
    required super.nome,
    required super.latitude,
    required super.longitude,
    required super.ativo,
  });

  factory CameraModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final location = data['localizacao'];

    return CameraModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      latitude: location is GeoPoint ? location.latitude : 0,
      longitude: location is GeoPoint ? location.longitude : 0,
      ativo: data['ativo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'localizacao': GeoPoint(latitude, longitude),
      'ativo': ativo,
    };
  }
}