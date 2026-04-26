import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_camera_locations.dart';
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
    ..registerLazySingleton<HomeRemoteDataSource>(HomeRemoteDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetCameraLocations(sl()))
    ..registerFactory(() => HomeCubit(sl(), sl()));
}