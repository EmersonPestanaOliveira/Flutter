import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../domain/entities/camera_location.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.remoteDataSource);

  final HomeRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<CameraLocation>>> getCameraLocations() async {
    try {
      final cameras = await remoteDataSource.getCameraLocations();
      return Right(cameras);
    } catch (error) {
      return Left(BackendErrorMapper.toFailure(error));
    }
  }
}