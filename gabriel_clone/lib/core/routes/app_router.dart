import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<HomeCubit>()..loadCameraLocations(),
        child: const HomePage(),
      ),
    ),
  ],
);