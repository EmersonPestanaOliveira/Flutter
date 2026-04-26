import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/camera_location.dart';
import '../repositories/home_repository.dart';

class GetCameraLocations {
  const GetCameraLocations(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, List<CameraLocation>>> call() {
    return repository.getCameraLocations();
  }
}