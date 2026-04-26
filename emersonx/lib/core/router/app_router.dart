import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [

    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => _fade(state, const SplashPage()),
    ),

    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => _slide(state, const HomePage()),
    ),

    GoRoute(
      path: AppRoutes.search,
      name: 'search',
      pageBuilder: (context, state) => _bottomSlide(state, const SearchPage()),
    ),

    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      pageBuilder: (context, state) => _slide(state, const SettingsPage()),
    ),

    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      pageBuilder: (context, state) => _slide(state, const AboutPage()),
    ),

    // TODO: adicionar rotas dos modulos
  ],

  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Rota nao encontrada: ${state.uri}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Voltar ao inicio'),
            ),
          ],
        ),
      ),
    ),
  ),
);

// Transicoes
CustomTransitionPage _fade(GoRouterState s, Widget child) =>
  CustomTransitionPage(
    key: s.pageKey, child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, anim, __, c) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
      child: c,
    ),
  );

CustomTransitionPage _slide(GoRouterState s, Widget child) =>
  CustomTransitionPage(
    key: s.pageKey, child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (_, anim, __, c) {
      final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: anim.drive(tween),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: c,
        ),
      );
    },
  );

CustomTransitionPage _bottomSlide(GoRouterState s, Widget child) =>
  CustomTransitionPage(
    key: s.pageKey, child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (_, anim, __, c) {
      final tween = Tween(begin: const Offset(0, 0.06), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: anim.drive(tween),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: c,
        ),
      );
    },
  );