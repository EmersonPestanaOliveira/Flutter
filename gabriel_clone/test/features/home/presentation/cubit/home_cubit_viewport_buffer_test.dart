import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta_filter.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_alertas_in_bounds_usecase.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/home_fixtures.dart';
import '../../../../helpers/home_mocks.dart';

/// Testes de performance percebida: o `_fetchInBounds` precisa carregar um
/// bounds expandido (viewport + buffer) para que pan/zoom curtos nao disparem
/// nova query, eliminando o flicker de pins que somem-e-voltam.
void main() {
  late MockGetCamerasUseCase getCamerasUseCase;
  late MockGetAlertasUseCase getAlertasUseCase;
  late MockGetAlertasInBoundsUseCase getAlertasInBoundsUseCase;

  setUpAll(() {
    registerFallbackValue(
      GetAlertasInBoundsParams(
        bounds: LatLngBounds(
          southwest: const LatLng(0, 0),
          northeast: const LatLng(0, 0),
        ),
        zoom: 0,
      ),
    );
  });

  setUp(() {
    getCamerasUseCase = MockGetCamerasUseCase();
    getAlertasUseCase = MockGetAlertasUseCase();
    getAlertasInBoundsUseCase = MockGetAlertasInBoundsUseCase();

    when(() => getCamerasUseCase(any()))
        .thenAnswer((_) async => const Right([testCamera]));
    when(() => getAlertasUseCase(any()))
        .thenAnswer((_) async => Right([testAlerta]));
    when(() => getAlertasInBoundsUseCase(any()))
        .thenAnswer((_) async => Right([testAlerta]));
  });

  HomeCubit buildCubit() => HomeCubit(
        getCamerasUseCase,
        getAlertasUseCase,
        getAlertasInBoundsUseCase,
      );

  // Atalhos de bounds para legibilidade nos testes.
  LatLngBounds box({
    required double south,
    required double west,
    required double north,
    required double east,
  }) {
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  Future<void> waitDebounce() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  test('query usa bounds 50% maior que o viewport visivel', () async {
    final cubit = buildCubit();
    await cubit.loadData();

    // Viewport 1° x 1°
    final viewport = box(south: -23.5, west: -47.0, north: -22.5, east: -46.0);
    cubit.onCameraIdle(viewport, 13);
    await waitDebounce();

    final captured = verify(() => getAlertasInBoundsUseCase(captureAny()))
        .captured
        .single as GetAlertasInBoundsParams;

    final passed = captured.bounds;
    final latSpan = passed.northeast.latitude - passed.southwest.latitude;
    final lonSpan = passed.northeast.longitude - passed.southwest.longitude;

    // 1° x 1° viewport com buffer 50% em cada lado → 2° x 2° passados.
    expect(latSpan, closeTo(2.0, 0.01));
    expect(lonSpan, closeTo(2.0, 0.01));

    await cubit.close();
  });

  test('pan curto dentro do buffer NAO refaz query', () async {
    final cubit = buildCubit();
    await cubit.loadData();

    cubit.onCameraIdle(
      box(south: -23.5, west: -47.0, north: -22.5, east: -46.0),
      13,
    );
    await waitDebounce();

    // Pan de 0.1° (10% do viewport) — bem dentro do buffer 50%.
    cubit.onCameraIdle(
      box(south: -23.5, west: -46.9, north: -22.5, east: -45.9),
      13,
    );
    await waitDebounce();

    // Apenas a primeira interacao chama o use case; a segunda usa cache.
    verify(() => getAlertasInBoundsUseCase(any())).called(1);

    await cubit.close();
  });

  test('pan grande FORA do buffer refaz query', () async {
    final cubit = buildCubit();
    await cubit.loadData();

    cubit.onCameraIdle(
      box(south: -23.5, west: -47.0, north: -22.5, east: -46.0),
      13,
    );
    await waitDebounce();

    // Pan de 2° (200% do viewport) → garantidamente fora do buffer.
    cubit.onCameraIdle(
      box(south: -23.5, west: -45.0, north: -22.5, east: -44.0),
      13,
    );
    await waitDebounce();

    verify(() => getAlertasInBoundsUseCase(any())).called(2);

    await cubit.close();
  });

  test('pan ate sair do buffer expandido refaz query', () async {
    final cubit = buildCubit();
    await cubit.loadData();

    // Viewport inicial 1° x 1° centrado em (-23.0, -46.5).
    //   west=-47.0, east=-46.0  →  expandido: west=-47.5, east=-45.5
    cubit.onCameraIdle(
      box(south: -23.5, west: -47.0, north: -22.5, east: -46.0),
      13,
    );
    await waitDebounce();

    // Pan de 0.3° para leste:
    //   west=-46.7, east=-45.7  →  east=-45.7 < -45.5 (dentro do buffer)
    cubit.onCameraIdle(
      box(south: -23.5, west: -46.7, north: -22.5, east: -45.7),
      13,
    );
    await waitDebounce();
    verify(() => getAlertasInBoundsUseCase(any())).called(1);

    // Pan extra de 0.5° para leste:
    //   west=-46.2, east=-45.2  →  east=-45.2 > -45.5 (FORA do buffer)
    cubit.onCameraIdle(
      box(south: -23.5, west: -46.2, north: -22.5, east: -45.2),
      13,
    );
    await waitDebounce();
    verify(() => getAlertasInBoundsUseCase(any())).called(2);

    await cubit.close();
  });

  test('mudanca de filtro forca re-fetch mesmo dentro do buffer', () async {
    final cubit = buildCubit();
    await cubit.loadData();

    final viewport = box(south: -23.5, west: -47.0, north: -22.5, east: -46.0);
    cubit.onCameraIdle(viewport, 13);
    await waitDebounce();

    cubit.updateFilter(const AlertaFilter(tipos: {AlertaTipo.violencia}));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verify(() => getAlertasInBoundsUseCase(any())).called(2);

    await cubit.close();
  });

  // ---------------------------------------------------------------------------
  // Acumulador de pins: pins ja carregados nao podem sumir do estado
  // ---------------------------------------------------------------------------

  test('pins do load inicial permanecem no estado apos viewport-fetch '
      'que retorna so um subconjunto', () async {
    // Prepara 5 pins espalhados — apenas o primeiro estara no viewport
    // restrito que sera consultado.
    final allAlertas = [
      _alertaAt('pin-1', -23.5, -46.6),
      _alertaAt('pin-2', -23.0, -46.0),
      _alertaAt('pin-3', -22.8, -45.9),
      _alertaAt('pin-4', -23.3, -46.4),
      _alertaAt('pin-5', -22.9, -46.1),
    ];

    when(() => getCamerasUseCase(any()))
        .thenAnswer((_) async => const Right([testCamera]));
    when(() => getAlertasUseCase(any()))
        .thenAnswer((_) async => Right(allAlertas));

    // O use case de viewport retorna so o primeiro pin. Sem o acumulador,
    // os outros 4 sumiriam do estado.
    when(() => getAlertasInBoundsUseCase(any()))
        .thenAnswer((_) async => Right([allAlertas.first]));

    final cubit = buildCubit();
    await cubit.loadData();

    expect((cubit.state as HomeLoaded).alertas.length, 5,
        reason: 'load inicial deve manter os 5 pins');

    cubit.onCameraIdle(
      box(south: -23.6, west: -46.7, north: -23.4, east: -46.5),
      14,
    );
    await waitDebounce();

    final loaded = cubit.state as HomeLoaded;
    expect(loaded.alertas.length, 5,
        reason: 'pins antigos nao podem sumir mesmo quando a query nova '
            'retorna apenas um subconjunto');
    expect(
      loaded.alertas.map((a) => a.id).toSet(),
      {'pin-1', 'pin-2', 'pin-3', 'pin-4', 'pin-5'},
    );

    await cubit.close();
  });

  test('mudanca de filtro descarta entradas antigas do acumulador', () async {
    final allAlertas = [
      _alertaAt('pin-1', -23.5, -46.6, tipo: AlertaTipo.violencia),
      _alertaAt('pin-2', -23.0, -46.0, tipo: AlertaTipo.acidente),
      _alertaAt('pin-3', -22.8, -45.9, tipo: AlertaTipo.estelionato),
    ];

    when(() => getCamerasUseCase(any()))
        .thenAnswer((_) async => const Right([testCamera]));
    when(() => getAlertasUseCase(any()))
        .thenAnswer((_) async => Right(allAlertas));

    // A primeira query (sem filtro) retorna todos.
    // A segunda query (com filtro violencia) retorna apenas pin-1.
    final responses = <List<Alerta>>[
      allAlertas,
      [allAlertas.first],
    ];
    when(() => getAlertasInBoundsUseCase(any()))
        .thenAnswer((_) async => Right(responses.removeAt(0)));

    final cubit = buildCubit();
    await cubit.loadData();
    cubit.onCameraIdle(
      box(south: -23.6, west: -47.0, north: -22.5, east: -45.5),
      13,
    );
    await waitDebounce();
    expect((cubit.state as HomeLoaded).alertas.length, 3);

    // Aplica filtro: o acumulador deve ser limpo e repopulado com a resposta
    // nova (so pin-1).
    cubit.updateFilter(const AlertaFilter(tipos: {AlertaTipo.violencia}));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final loaded = cubit.state as HomeLoaded;
    expect(loaded.alertas.length, 1,
        reason: 'apos mudanca de filtro, apenas pins do novo recorte ficam');
    expect(loaded.alertas.single.id, 'pin-1');

    await cubit.close();
  });
}

Alerta _alertaAt(
  String id,
  double lat,
  double lon, {
  AlertaTipo tipo = AlertaTipo.outros,
}) {
  return Alerta(
    id: id,
    bairro: 'Bairro',
    cidade: 'Sao Paulo',
    data: DateTime(2026, 5, 1),
    descricao: 'Sintetico',
    tipo: tipo,
    latitude: lat,
    longitude: lon,
  );
}
