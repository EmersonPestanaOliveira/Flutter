import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/usecases/usecase.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:gabriel_clone/features/home/presentation/cubit/home_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/home_fixtures.dart';
import '../../../../helpers/home_mocks.dart';

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
      HomeLoaded(cameras: const [testCamera], alertas: [testAlerta]),
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
