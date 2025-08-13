import 'package:ecommerce/app/micro_app_auth/presentation/pages/login_page.dart';
import 'package:ecommerce/app/micro_app_home/presentation/pages/home_page.dart';
import 'package:ecommerce/app/micro_app_splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

// Adicione suas rotas aqui

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      /*GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListPage(),
      ),*/
      // Outras rotas
    ],
  );
}
