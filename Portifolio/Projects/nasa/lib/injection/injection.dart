import 'package:get_it/get_it.dart';

import '../data/datasources/nasa_api/nasa_api_datasource.dart';
import '../data/repositories/image_repository_impl.dart';
import '../domain/repositories/image_repository.dart';
import '../domain/usecases/get_images_usecase.dart';
import '../presentation/providers/image_provider.dart';

final getIt = GetIt.instance;

void setupInjector() {
  // Datasources
  getIt.registerLazySingleton<NasaApiDatasource>(() => NasaApiDatasourceImpl());

  // Repositórios
  getIt.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(getIt<NasaApiDatasource>()),
  );

  // Usecases
  getIt.registerLazySingleton<GetImagesUseCase>(
    () => GetImagesUseCase(getIt<ImageRepository>()),
  );

  // Providers
  getIt.registerFactory<ImageChangeNotifier>(
    () => ImageChangeNotifier(getIt<GetImagesUseCase>()),
  );
}
