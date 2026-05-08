import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/geo/geo_utils.dart';
import '../../../../core/utils/text_normalizer.dart';
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
    super.clientId,
  });

  factory AlertaModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawDate = data['data'];
    final rawType = data['tipo'] as String? ?? '';
    final location = _readLocation(data);

    return AlertaModel(
      id: doc.id,
      bairro: data['bairro'] as String? ?? '',
      cidade: data['cidade'] as String? ?? '',
      data: rawDate is Timestamp
          ? rawDate.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      descricao: data['descricao'] as String? ?? '',
      tipo: alertaTipoFromString(rawType),
      latitude: location.latitude,
      longitude: location.longitude,
      clientId: data['clientId'] as String? ?? doc.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bairro': bairro,
      'cidade': cidade,
      'data': Timestamp.fromDate(data),
      'descricao': descricao,
      'tipo': tipo.label,
      'clientId': clientId ?? id,
      'localizacao': GeoPoint(latitude, longitude),
      'geohash': GeoUtils.geohash(latitude, longitude),
    };
  }

  static ({double latitude, double longitude}) _readLocation(
    Map<String, dynamic> data,
  ) {
    final location = data['localizacao'];
    if (location is GeoPoint) {
      return (latitude: location.latitude, longitude: location.longitude);
    }

    final latitude = _readDouble(data['latitude'] ?? data['lat']);
    final longitude = _readDouble(data['longitude'] ?? data['lng']);
    if (latitude != null && longitude != null) {
      return (latitude: latitude, longitude: longitude);
    }

    return _fallbackLocationForNeighborhood(
      data['bairro'] as String? ?? '',
      data['cidade'] as String? ?? '',
    );
  }

  static double? _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.'));
    }
    return null;
  }

  static ({double latitude, double longitude}) _fallbackLocationForNeighborhood(
    String bairro,
    String cidade,
  ) {
    final normalized = normalizeSearchText('$bairro $cidade');

    if (normalized.contains('consolacao')) {
      return (latitude: -23.5579, longitude: -46.6608);
    }
    if (normalized.contains('se sao paulo')) {
      return (latitude: -23.5505, longitude: -46.6333);
    }
    if (normalized.contains('pinheiros')) {
      return (latitude: -23.5676, longitude: -46.6927);
    }
    if (normalized.contains('santana')) {
      return (latitude: -23.5015, longitude: -46.6259);
    }
    if (normalized.contains('vila mariana')) {
      return (latitude: -23.5892, longitude: -46.6344);
    }
    if (normalized.contains('mooca')) {
      return (latitude: -23.5607, longitude: -46.5972);
    }
    if (normalized.contains('lapa')) {
      return (latitude: -23.5247, longitude: -46.7034);
    }
    if (normalized.contains('ibirapuera')) {
      return (latitude: -23.5874, longitude: -46.6576);
    }
    if (normalized.contains('santo andre')) {
      return (latitude: -23.6563, longitude: -46.5322);
    }
    if (normalized.contains('luz')) {
      return (latitude: -23.5362, longitude: -46.6336);
    }

    return (latitude: 0, longitude: 0);
  }

}
