import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/camera_location.dart';
import '../repositories/home_repository.dart';

class GetCameraLocations implements UseCase<List<CameraLocation>, NoParams> {
  const GetCameraLocations(this.repository);

  final HomeRepository repository;

  @override
  Future<AppResult<List<CameraLocation>>> call(NoParams params) {
    return repository.getCameraLocations();
  }
}
