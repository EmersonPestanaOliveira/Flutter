import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_camera_locations.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../firebase/firebase_connection_validator.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton(FirebaseConnectionValidator.new)
    ..registerLazySingleton<HomeRemoteDataSource>(
      HomeRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => GetCameraLocations(getIt()))
    ..registerFactory(() => HomeCubit(getIt(), getIt()));
}