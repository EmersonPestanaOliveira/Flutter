import 'package:equatable/equatable.dart';

import '../enums/alerta_tipo.dart';

class Alerta extends Equatable {
  const Alerta({
    required this.id,
    required this.bairro,
    required this.cidade,
    required this.data,
    required this.descricao,
    required this.tipo,
    required this.latitude,
    required this.longitude,
    this.localSyncStatus,
    this.localError,
  });

  final String id;
  final String bairro;
  final String cidade;
  final DateTime data;
  final String descricao;
  final AlertaTipo tipo;
  final double latitude;
  final double longitude;
  final String? localSyncStatus;
  final String? localError;

  bool get isLocalPending => localSyncStatus != null;

  @override
  List<Object?> get props => [
        id,
        bairro,
        cidade,
        data,
        descricao,
        tipo,
        latitude,
        longitude,
        localSyncStatus,
        localError,
      ];
}
