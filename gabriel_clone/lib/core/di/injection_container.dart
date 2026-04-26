import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/alerta_remote_datasource.dart';
import '../../features/home/data/datasources/camera_remote_datasource.dart';
import '../../features/home/data/repositories/alerta_repository_impl.dart';
import '../../features/home/data/repositories/camera_repository_impl.dart';
import '../../features/home/domain/repositories/alerta_repository.dart';
import '../../features/home/domain/repositories/camera_repository.dart';
import '../../features/home/domain/usecases/get_alertas_usecase.dart';
import '../../features/home/domain/usecases/get_cameras_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../firebase/firebase_connection_validator.dart';
import '../theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl
    ..registerLazySingleton(ThemeCubit.new)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseConnectionValidator(firestore: sl()))
    ..registerLazySingleton<CameraRemoteDatasource>(
      () => CameraRemoteDatasourceImpl(sl()),
    )
    ..registerLazySingleton<AlertaRemoteDatasource>(
      () => AlertaRemoteDatasourceImpl(sl()),
    )
    ..registerLazySingleton<CameraRepository>(
      () => CameraRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AlertaRepository>(
      () => AlertaRepositoryImpl(sl()),
    )
    ..registerFactory(() => GetCamerasUseCase(sl()))
    ..registerFactory(() => GetAlertasUseCase(sl()))
    ..registerFactory(() => HomeCubit(sl(), sl()));
}