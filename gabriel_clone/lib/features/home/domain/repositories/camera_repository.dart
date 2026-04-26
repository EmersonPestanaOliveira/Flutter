import '../../../../core/types/app_result.dart';
import '../entities/camera.dart';

abstract interface class CameraRepository {
  Future<AppResult<List<Camera>>> getCameras();
}