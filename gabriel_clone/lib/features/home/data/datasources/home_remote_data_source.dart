import '../../domain/entities/camera_location.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<CameraLocation>> getCameraLocations();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<CameraLocation>> getCameraLocations() async {
    return const [];
  }
}
