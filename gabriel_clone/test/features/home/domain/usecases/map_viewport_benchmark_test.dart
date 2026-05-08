import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/geo/geo_utils.dart';
import 'package:gabriel_clone/core/types/app_result.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta_filter.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/domain/repositories/alerta_repository.dart';
import 'package:gabriel_clone/features/home/domain/services/alerta_cluster_service.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_alertas_in_bounds_usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../helpers/home_fixtures.dart';

void main() {
  const sizes = [1000, 5000, 10000, 50000];
  final bounds = LatLngBounds(
    southwest: const LatLng(-23.80, -46.90),
    northeast: const LatLng(-23.45, -46.45),
  );
  final filter = AlertaFilter(
    tipos: {AlertaTipo.rouboFurto, AlertaTipo.violencia, AlertaTipo.outros},
    dateFrom: DateTime(2026, 4, 1),
    dateTo: DateTime(2026, 4, 30),
  );

  test('benchmark viewport filter e cluster build', () async {
    debugPrint(
      'MAP_BENCHMARK size filter_p50 filter_p95 cluster_p50 cluster_p95',
    );
    for (final size in sizes) {
      final alertas = syntheticAlertas(size);
      final repository = FakeAlertaRepository(alertas);
      final useCase = GetAlertasInBoundsUseCase(repository);

      final filterSamples = <int>[];
      final clusterSamples = <int>[];
      List<Alerta> filtered = const [];

      for (var i = 0; i < 9; i++) {
        final filterWatch = Stopwatch()..start();
        final result = await useCase(
          GetAlertasInBoundsParams(bounds: bounds, zoom: 13, filter: filter),
        );
        filterWatch.stop();
        filtered = result.getOrElse(() => const []);
        filterSamples.add(filterWatch.elapsedMicroseconds);

        final clusterWatch = Stopwatch()..start();
        AlertaClusterService.build(filtered, 13);
        clusterWatch.stop();
        clusterSamples.add(clusterWatch.elapsedMicroseconds);
      }

      debugPrint(
        'MAP_BENCHMARK $size '
        '${_p50(filterSamples)}us ${_p95(filterSamples)}us '
        '${_p50(clusterSamples)}us ${_p95(clusterSamples)}us '
        'filtered=${filtered.length}',
      );

      expect(filtered.length, greaterThan(0));
    }
  });
}

int _p50(List<int> samples) => _percentile(samples, 0.50);
int _p95(List<int> samples) => _percentile(samples, 0.95);

int _percentile(List<int> samples, double percentile) {
  final sorted = [...samples]..sort();
  final index = ((sorted.length - 1) * percentile).round();
  return sorted[index];
}

class FakeAlertaRepository implements AlertaRepository {
  const FakeAlertaRepository(this.alertas);

  final List<Alerta> alertas;

  @override
  Future<AppResult<List<Alerta>>> getAlertas() async => Right(alertas);

  @override
  Future<AppResult<List<Alerta>>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  }) async {
    return Right(alertas);
  }
}
