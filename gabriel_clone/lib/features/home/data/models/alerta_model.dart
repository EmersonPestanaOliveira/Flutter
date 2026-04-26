import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';

class AlertaModel extends Alerta {
  const AlertaModel({
    required super.id,
    required super.bairro,
    required super.cidade,
    required super.data,
    required super.descricao,
    required super.tipo,
    required super.latitude,
    required super.longitude,
  });

  factory AlertaModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawDate = data['data'];
    final rawType = data['tipo'] as String? ?? '';
    final location = data['localizacao'];

    return AlertaModel(
      id: doc.id,
      bairro: data['bairro'] as String? ?? '',
      cidade: data['cidade'] as String? ?? '',
      data: rawDate is Timestamp
          ? rawDate.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      descricao: data['descricao'] as String? ?? '',
      tipo: alertaTipoFromString(rawType),
      latitude: location is GeoPoint ? location.latitude : 0,
      longitude: location is GeoPoint ? location.longitude : 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bairro': bairro,
      'cidade': cidade,
      'data': Timestamp.fromDate(data),
      'descricao': descricao,
      'tipo': tipo.label,
      'localizacao': GeoPoint(latitude, longitude),
    };
  }
}