import 'package:equatable/equatable.dart';

import '../enums/alerta_tipo.dart';

/// Filtro de domínio para alertas.
///
/// [tipos]    — conjunto de tipos permitidos; vazio = todos os tipos.
/// [dateFrom] — data inicial (inclusive); null = sem limite inferior.
/// [dateTo]   — data final (inclusive);   null = sem limite superior.
/// [radius]   — raio em km ao redor de um ponto; null = sem filtro de raio.
///              (preparado para escala, mas ainda não usado na busca por GeoHash)
class AlertaFilter extends Equatable {
  const AlertaFilter({
    this.tipos = const {},
    this.dateFrom,
    this.dateTo,
    this.radius,
    this.centerLatitude,
    this.centerLongitude,
  });

  final Set<AlertaTipo> tipos;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? radius;
  final double? centerLatitude;
  final double? centerLongitude;

  /// Retorna `true` quando nenhum critério de filtro está ativo.
  bool get isEmpty =>
      tipos.isEmpty &&
      dateFrom == null &&
      dateTo == null &&
      radius == null &&
      centerLatitude == null &&
      centerLongitude == null;

  AlertaFilter copyWith({
    Set<AlertaTipo>? tipos,
    Object? dateFrom = _sentinel,
    Object? dateTo = _sentinel,
    Object? radius = _sentinel,
    Object? centerLatitude = _sentinel,
    Object? centerLongitude = _sentinel,
  }) {
    return AlertaFilter(
      tipos: tipos ?? this.tipos,
      dateFrom: dateFrom == _sentinel ? this.dateFrom : dateFrom as DateTime?,
      dateTo: dateTo == _sentinel ? this.dateTo : dateTo as DateTime?,
      radius: radius == _sentinel ? this.radius : radius as double?,
      centerLatitude: centerLatitude == _sentinel
          ? this.centerLatitude
          : centerLatitude as double?,
      centerLongitude: centerLongitude == _sentinel
          ? this.centerLongitude
          : centerLongitude as double?,
    );
  }

  @override
  List<Object?> get props => [
    tipos,
    dateFrom,
    dateTo,
    radius,
    centerLatitude,
    centerLongitude,
  ];
}

const _sentinel = Object();
