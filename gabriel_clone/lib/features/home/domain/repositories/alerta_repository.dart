import '../../../../core/types/app_result.dart';
import '../entities/alerta.dart';

abstract interface class AlertaRepository {
  Future<AppResult<List<Alerta>>> getAlertas();
}