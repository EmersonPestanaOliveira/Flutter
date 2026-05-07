import 'package:gabriel_clone/features/home/domain/repositories/alerta_repository.dart';
import 'package:gabriel_clone/features/home/domain/repositories/camera_repository.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_alertas_usecase.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_alertas_in_bounds_usecase.dart';
import 'package:gabriel_clone/features/home/domain/usecases/get_cameras_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCameraRepository extends Mock implements CameraRepository {}

class MockAlertaRepository extends Mock implements AlertaRepository {}

class MockGetCamerasUseCase extends Mock implements GetCamerasUseCase {}

class MockGetAlertasUseCase extends Mock implements GetAlertasUseCase {}

class MockGetAlertasInBoundsUseCase extends Mock
    implements GetAlertasInBoundsUseCase {}
