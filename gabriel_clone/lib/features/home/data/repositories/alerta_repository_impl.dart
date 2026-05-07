import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/geo/geo_utils.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../../../core/types/app_result.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/repositories/alerta_repository.dart';
import '../datasources/alerta_remote_datasource.dart';

class AlertaRepositoryImpl implements AlertaRepository {
  const AlertaRepositoryImpl(this.remoteDatasource);

  final AlertaRemoteDatasource remoteDatasource;

  @override
  Future<AppResult<List<Alerta>>> getAlertas() async {
    try {
      final alertas = await remoteDatasource.getAlertas();
      return Right(alertas);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(BackendErrorMapper.toFailure(error));
    }
  }

  @override
  Future<AppResult<List<Alerta>>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  }) async {
    try {
      final alertas = await remoteDatasource.getAlertasInBounds(
        bounds: bounds,
        filter: filter,
        zoom: zoom,
      );
      return Right(alertas);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(BackendErrorMapper.toFailure(error));
    }
  }
}
