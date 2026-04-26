import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alerta.dart';
import '../repositories/alerta_repository.dart';

class GetAlertasUseCase implements UseCase<List<Alerta>, NoParams> {
  const GetAlertasUseCase(this.repository);

  final AlertaRepository repository;

  @override
  Future<AppResult<List<Alerta>>> call(NoParams params) {
    return repository.getAlertas();
  }
}