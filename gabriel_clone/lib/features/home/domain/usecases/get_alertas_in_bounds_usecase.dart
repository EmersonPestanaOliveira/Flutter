import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/geo/geo_utils.dart';
import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alerta.dart';
import '../entities/alerta_filter.dart';
import '../repositories/alerta_repository.dart';

class GetAlertasInBoundsParams extends Equatable {
  const GetAlertasInBoundsParams({
    required this.bounds,
    required this.zoom,
    this.filter = const AlertaFilter(),
  });

  final LatLngBounds bounds;
  final double zoom;
  final AlertaFilter filter;

  @override
  List<Object?> get props => [bounds, zoom, filter];
}

/// Retorna os alertas visíveis no viewport atual, aplicando o [AlertaFilter].
///
/// Implementação atual: filtra em memória a partir de todos os alertas carregados.
///
/// // TODO: substituir por GeoQuery (geoflutterfire2 ou GeoHash) quando volume crescer.
/// Passos para escalar:
/// 1. Codificar cada [Alerta.latitude/longitude] como GeoHash no Firestore.
/// 2. Usar `geoflutterfire_plus` com `withinAsBroadStream(center, radiusKm)`.
/// 3. Combinar com filtros de tipo via composição de queries no Firestore.
class GetAlertasInBoundsUseCase
    implements UseCase<List<Alerta>, GetAlertasInBoundsParams> {
  const GetAlertasInBoundsUseCase(this._repository);

  final AlertaRepository _repository;

  @override
  Future<AppResult<List<Alerta>>> call(GetAlertasInBoundsParams params) async {
    final result = await _repository.getAlertasInBounds(
      bounds: GeoBounds(
        south: params.bounds.southwest.latitude,
        west: params.bounds.southwest.longitude,
        north: params.bounds.northeast.latitude,
        east: params.bounds.northeast.longitude,
      ),
      filter: params.filter,
      zoom: params.zoom,
    );
    return result.map((alertas) => _filterInBounds(alertas, params));
  }

  List<Alerta> _filterInBounds(
    List<Alerta> alertas,
    GetAlertasInBoundsParams params,
  ) {
    final ne = params.bounds.northeast;
    final sw = params.bounds.southwest;

    return alertas.where((alerta) {
      // Filtro geográfico pelo bounds do viewport
      final inBounds = alerta.latitude >= sw.latitude &&
          alerta.latitude <= ne.latitude &&
          alerta.longitude >= sw.longitude &&
          alerta.longitude <= ne.longitude;

      if (!inBounds) return false;

      // Aplica AlertaFilter de domínio (tipo / data)
      if (params.filter.isEmpty) return true;

      if (params.filter.tipos.isNotEmpty &&
          !params.filter.tipos.contains(alerta.tipo)) {
        return false;
      }
      if (params.filter.dateFrom != null &&
          alerta.data.isBefore(params.filter.dateFrom!)) {
        return false;
      }
      if (params.filter.dateTo != null &&
          alerta.data.isAfter(
            params.filter.dateTo!.add(const Duration(days: 1)),
          )) {
        return false;
      }

      return true;
    }).toList(growable: false);
  }
}
