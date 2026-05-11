import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/usecases/usecase.dart';
import 'package:gabriel_clone/features/home/data/services/stress_pins_config_service.dart';
import 'package:gabriel_clone/features/home/domain/services/stress_pins_generator.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/home_fixtures.dart';
import '../../../../helpers/home_mocks.dart';

class _FakeStressPinsConfigService implements StressPinsConfigService {
  _FakeStressPinsConfigService(this.config);

  final StressPinsConfig config;

  @override
  Future<StressPinsConfig> loadConfig() async => config;
}

void main() {
  late MockGetCamerasUseCase getCamerasUseCase;
  late MockGetAlertasUseCase getAlertasUseCase;
  late MockGetAlertasInBoundsUseCase getAlertasInBoundsUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getCamerasUseCase = MockGetCamerasUseCase();
    getAlertasUseCase = MockGetAlertasUseCase();
    getAlertasInBoundsUseCase = MockGetAlertasInBoundsUseCase();
  });

  HomeCubit buildCubit() => HomeCubit(
    getCamerasUseCase,
    getAlertasUseCase,
    getAlertasInBoundsUseCase,
  );

  HomeCubit buildCubitWithStress(StressPinsConfig config) => HomeCubit(
    getCamerasUseCase,
    getAlertasUseCase,
    getAlertasInBoundsUseCase,
    stressPinsConfigService: _FakeStressPinsConfigService(config),
    stressPinsGenerator: const StressPinsGenerator(),
  );

  blocTest<HomeCubit, HomeState>(
    'loadData emite Loading e Loaded em sucesso',
    setUp: () {
      when(
        () => getCamerasUseCase(any()),
      ).thenAnswer((_) async => const Right([testCamera]));
      when(
        () => getAlertasUseCase(any()),
      ).thenAnswer((_) async => Right([testAlerta]));
    },
    build: buildCubit,
    act: (cubit) => cubit.loadData(),
    expect: () => [
      const HomeLoading(),
      const HomeLoaded(cameras: [testCamera], alertas: []),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'loadData adiciona pins sinteticos apenas quando stress flag esta ligada',
    setUp: () {
      when(
        () => getCamerasUseCase(any()),
      ).thenAnswer((_) async => const Right([testCamera]));
      when(
        () => getAlertasUseCase(any()),
      ).thenAnswer((_) async => Right([testAlerta]));
    },
    build: () => buildCubitWithStress(
      const StressPinsConfig(enabled: true, count: 3),
    ),
    act: (cubit) => cubit.loadData(),
    expect: () => [
      const HomeLoading(),
      isA<HomeLoaded>()
          .having((state) => state.alertas.length, 'alertas.length', 3)
          .having(
            (state) => state.alertas.where((a) => a.id.startsWith('stress-sp-')).length,
            'stress pin count',
            3,
          ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'loadData preserva caminho normal quando stress flag esta desligada',
    setUp: () {
      when(
        () => getCamerasUseCase(any()),
      ).thenAnswer((_) async => const Right([testCamera]));
      when(
        () => getAlertasUseCase(any()),
      ).thenAnswer((_) async => Right([testAlerta]));
    },
    build: () => buildCubitWithStress(
      const StressPinsConfig(enabled: false, count: 100000),
    ),
    act: (cubit) => cubit.loadData(),
    expect: () => [
      const HomeLoading(),
      const HomeLoaded(cameras: [testCamera], alertas: []),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'loadData emite Loading e Error em falha',
    setUp: () {
      when(() => getCamerasUseCase(any())).thenAnswer(
        (_) async => const Left(PoorConnectionFailure(code: 'unavailable')),
      );
      when(
        () => getAlertasUseCase(any()),
      ).thenAnswer((_) async => Right([testAlerta]));
    },
    build: buildCubit,
    act: (cubit) => cubit.loadData(),
    expect: () => const [
      HomeLoading(),
      HomeError(
        message:
            'Sua conexao esta instavel. Tente novamente em alguns instantes.',
      ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'changeTab emite HomeLoaded com tabIndex atualizado',
    build: buildCubit,
    seed: () => HomeLoaded(cameras: const [testCamera], alertas: [testAlerta]),
    act: (cubit) => cubit.changeTab(1),
    expect: () => [
      HomeLoaded(
        cameras: const [testCamera],
        alertas: [testAlerta],
        tabIndex: 1,
      ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'setAlertMapEnabled desativa alertas e volta para Camaleoes',
    build: buildCubit,
    seed: () => HomeLoaded(
      cameras: const [testCamera],
      alertas: [testAlerta],
      tabIndex: 1,
    ),
    act: (cubit) => cubit.setAlertMapEnabled(false),
    expect: () => [
      HomeLoaded(
        cameras: const [testCamera],
        alertas: [testAlerta],
        tabIndex: 0,
        isAlertMapEnabled: false,
      ),
    ],
  );
}
