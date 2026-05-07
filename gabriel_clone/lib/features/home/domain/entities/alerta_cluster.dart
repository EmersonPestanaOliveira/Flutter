import 'package:equatable/equatable.dart';

import 'alerta.dart';

/// Representa um agrupamento de alertas próximos no mapa.
///
/// Um cluster pode conter de 1 a N alertas. Quando [count] == 1,
/// o cluster representa um pin individual; quando > 1, é exibido
/// como um marcador de cluster com contador.
class AlertaCluster extends Equatable {
  const AlertaCluster({
    required this.id,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.alertas,
    required this.cellKey,
  });

  /// ID único do cluster (baseado na célula geohash).
  final String id;

  /// Latitude do centróide do cluster.
  final double centerLatitude;

  /// Longitude do centróide do cluster.
  final double centerLongitude;

  /// Alertas contidos no cluster.
  final List<Alerta> alertas;

  /// Chave da célula geohash que originou o cluster.
  final String cellKey;

  int get count => alertas.length;
  bool get isCluster => count > 1;
  Alerta? get singleAlerta => count == 1 ? alertas.first : null;

  @override
  List<Object?> get props => [id, centerLatitude, centerLongitude, cellKey];
}
