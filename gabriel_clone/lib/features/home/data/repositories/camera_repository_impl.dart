import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/app_result.dart';
import '../../domain/entities/camera.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_remote_datasource.dart';

class CameraRepositoryImpl implements CameraRepository {
  const CameraRepositoryImpl(this.remoteDatasource);

  final CameraRemoteDatasource remoteDatasource;

  @override
  Future<AppResult<List<Camera>>> getCameras() async {
    try {
      final cameras = await remoteDatasource.getCameras();
      return Right(cameras);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(UnknownFailure(log: error));
    }
  }
}