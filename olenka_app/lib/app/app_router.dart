import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_routes.dart';
import '../features/auth/data/auth_service.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/unlock_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

bool _biometricEnabledCache = false;

void updateBiometricCache(bool value) {
  _biometricEnabledCache = value;
}

Future<void> warmUpBiometricCache(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  _biometricEnabledCache = prefs.getBool('biometric_enabled_$uid') ?? false;
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: GoRouterRefreshStream(
    AuthService.instance.authStateChanges,
  ),
  redirect: (context, state) {
    final loggedIn = AuthService.instance.currentUser != null;
    final location = state.matchedLocation;

    if (location == AppRoutes.splash) return null;

    const publicRoutes = {
      AppRoutes.login,
      AppRoutes.signup,
      AppRoutes.forgotPassword,
    };
    final isPublic = publicRoutes.contains(location);

    if (!loggedIn) {
      return isPublic ? null : AppRoutes.login;
    }

    if (isPublic) return AppRoutes.home;

    if (_biometricEnabledCache &&
        !isSessionUnlocked() &&
        location != AppRoutes.unlock) {
      return AppRoutes.unlock;
    }

    if (location == AppRoutes.unlock && !_biometricEnabledCache) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.unlock,
      name: 'unlock',
      builder: (context, state) => const UnlockPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);