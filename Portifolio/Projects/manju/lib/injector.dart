import 'package:get_it/get_it.dart';
import 'package:manju/controllers/client_controller.dart';
import 'package:manju/controllers/service_controller.dart';
import 'package:manju/controllers/product_controller.dart';
import 'package:manju/data/repositories/client_repository.dart';
import 'package:manju/data/repositories/service_repository.dart';
import 'package:manju/data/repositories/product_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Repositórios
  getIt.registerLazySingleton<ClientRepository>(() => ClientRepository());
  getIt.registerLazySingleton<ServiceRepository>(() => ServiceRepository());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // Controllers
  getIt.registerFactory<ClientController>(
      () => ClientController(getIt<ClientRepository>()));
  getIt.registerFactory<ServiceController>(
      () => ServiceController(getIt<ServiceRepository>()));
  getIt.registerFactory<ProductController>(
      () => ProductController(getIt<ProductRepository>()));
}
