import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/camera_location.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<CameraLocation>>> getCameraLocations();
}