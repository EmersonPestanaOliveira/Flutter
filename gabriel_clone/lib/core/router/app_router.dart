import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/soon_page.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRouteNames.home,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<HomeCubit>()..loadCameraLocations(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.ocorrencias,
        name: AppRouteNames.ocorrencias,
        builder: (context, state) => const SoonPage(title: 'Ocorrencias'),
      ),
      GoRoute(
        path: AppRoutes.placas,
        name: AppRouteNames.placas,
        builder: (context, state) => const SoonPage(title: 'Placas'),
      ),
      GoRoute(
        path: AppRoutes.imagens,
        name: AppRouteNames.imagens,
        builder: (context, state) => const SoonPage(title: 'Imagens'),
      ),
    ],
  );
}