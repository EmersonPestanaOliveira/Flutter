import '../../../../core/types/app_result.dart';
import '../../../../core/geo/geo_utils.dart';
import '../entities/alerta.dart';
import '../entities/alerta_filter.dart';

abstract interface class AlertaRepository {
  Future<AppResult<List<Alerta>>> getAlertas();
  Future<AppResult<List<Alerta>>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  });
}
