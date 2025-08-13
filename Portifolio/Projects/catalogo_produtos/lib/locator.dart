import 'package:get_it/get_it.dart';
import 'repositories/product_repository.dart';
import 'viewmodels/product_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepository());
  getIt.registerFactory<ProductViewModel>(
    () => ProductViewModel(getIt<ProductRepository>()),
  );
}
