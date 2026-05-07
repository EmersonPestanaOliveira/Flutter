import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/images/presentation/screens/images_screen.dart';
import '../../features/menu/presentation/menu_pages.dart';
import '../../features/ocorrencias/presentation/screens/minhas_ocorrencias_screen.dart';
import '../../features/ocorrencias/presentation/screens/ocorrencia_form_screen.dart';
import '../../features/ocorrencias/presentation/screens/ocorrencia_info_screen.dart';
import '../../features/ocorrencias/presentation/screens/ocorrencia_success_screen.dart';
import '../../features/ocorrencias/presentation/screens/ocorrencias_screen.dart';
import '../../features/placas/presentation/screens/placas_form_screen.dart';
import '../../features/placas/presentation/screens/placas_info_screen.dart';
import '../../features/placas/presentation/screens/placas_screen.dart';
import '../../features/placas/presentation/screens/placas_success_screen.dart';
import '../../features/resultados/presentation/screens/resultados_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final location = state.uri.path;
      final isSplashRoute = location == AppRoutes.splash;
      final isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.register;

      if (isSplashRoute) return null;
      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.ocorrencias,
        name: AppRouteNames.ocorrencias,
        builder: (context, state) => const OcorrenciasScreen(),
      ),
      GoRoute(
        path: AppRoutes.ocorrenciasInfo,
        name: AppRouteNames.ocorrenciasInfo,
        builder: (context, state) => const OcorrenciaInfoScreen(),
      ),
      GoRoute(
        path: AppRoutes.ocorrenciasForm,
        name: AppRouteNames.ocorrenciasForm,
        builder: (context, state) => const OcorrenciaFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.minhasOcorrencias,
        name: AppRouteNames.minhasOcorrencias,
        builder: (context, state) => const MinhasOcorrenciasScreen(),
      ),
      GoRoute(
        path: AppRoutes.ocorrenciasSuccess,
        name: AppRouteNames.ocorrenciasSuccess,
        builder: (context, state) => const OcorrenciaSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.placas,
        name: AppRouteNames.placas,
        builder: (context, state) => const PlacasScreen(),
      ),
      GoRoute(
        path: AppRoutes.placasInfo,
        name: AppRouteNames.placasInfo,
        builder: (context, state) => const PlacasInfoScreen(),
      ),
      GoRoute(
        path: AppRoutes.placasForm,
        name: AppRouteNames.placasForm,
        builder: (context, state) => const PlacasFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.placasSuccess,
        name: AppRouteNames.placasSuccess,
        builder: (context, state) => const PlacasSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.imagens,
        name: AppRouteNames.imagens,
        builder: (context, state) => const ImagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.addPlace,
        name: AppRouteNames.addPlace,
        builder: (context, state) => const AddPlacePage(),
      ),
      GoRoute(
        path: AppRoutes.technicalSupport,
        name: AppRouteNames.technicalSupport,
        builder: (context, state) => const TechnicalSupportPage(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: AppRouteNames.about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        name: AppRouteNames.faq,
        builder: (context, state) => const FaqPage(),
      ),
      GoRoute(
        path: AppRoutes.resultados,
        name: AppRouteNames.resultados,
        builder: (context, state) => const ResultadosScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
