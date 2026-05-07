import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/usecases/usecase.dart';
import 'package:gabriel_clone/features/home/domain/entities/camera.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_cameras_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/home_fixtures.dart';
import '../../../../helpers/home_mocks.dart';

void main() {
  late MockCameraRepository repository;
  late GetCamerasUseCase useCase;

  setUp(() {
    repository = MockCameraRepository();
    useCase = GetCamerasUseCase(repository);
  });

  test('retorna lista de cameras quando repository tem sucesso', () async {
    when(() => repository.getCameras()).thenAnswer(
      (_) async => const Right([testCamera]),
    );

    final result = await useCase(const NoParams());

    expect(result, const Right([testCamera]));
    verify(() => repository.getCameras()).called(1);
  });

  test('retorna NetworkFailure quando repository falha por rede', () async {
    const failure = NetworkFailure(code: 'unavailable');
    when(() => repository.getCameras()).thenAnswer(
      (_) async => const Left(failure),
    );

    final result = await useCase(const NoParams());

    expect(result, const Left(failure));
    verify(() => repository.getCameras()).called(1);
  });

  test('retorna lista vazia sem erro', () async {
    when(() => repository.getCameras()).thenAnswer(
      (_) async => const Right(<Camera>[]),
    );

    final result = await useCase(const NoParams());

    result.fold(
      (_) => fail('Nao deveria falhar'),
      (cameras) => expect(cameras, isEmpty),
    );
    verify(() => repository.getCameras()).called(1);
  });
}