import '../../../../core/types/app_result.dart';
import '../entities/camera_location.dart';

abstract interface class HomeRepository {
  Future<AppResult<List<CameraLocation>>> getCameraLocations();
}
