import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/camera.dart';
import '../repositories/camera_repository.dart';

class GetCamerasUseCase implements UseCase<List<Camera>, NoParams> {
  const GetCamerasUseCase(this.repository);

  final CameraRepository repository;

  @override
  Future<AppResult<List<Camera>>> call(NoParams params) {
    return repository.getCameras();
  }
}