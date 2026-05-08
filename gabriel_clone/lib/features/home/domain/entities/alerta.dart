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
    this.clientId,
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
  final String? clientId;
  final String? localSyncStatus;
  final String? localError;

  bool get isLocalPending => localSyncStatus != null;
  String get mergeKey => clientId?.isNotEmpty == true ? clientId! : id;

  Alerta copyWith({
    String? id,
    String? bairro,
    String? cidade,
    DateTime? data,
    String? descricao,
    AlertaTipo? tipo,
    double? latitude,
    double? longitude,
    Object? clientId = _sentinel,
    Object? localSyncStatus = _sentinel,
    Object? localError = _sentinel,
  }) {
    return Alerta(
      id: id ?? this.id,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      clientId: clientId == _sentinel ? this.clientId : clientId as String?,
      localSyncStatus: localSyncStatus == _sentinel
          ? this.localSyncStatus
          : localSyncStatus as String?,
      localError:
          localError == _sentinel ? this.localError : localError as String?,
    );
  }

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
        clientId,
        localSyncStatus,
        localError,
      ];
}

const _sentinel = Object();
