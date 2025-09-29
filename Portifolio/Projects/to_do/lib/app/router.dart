import 'package:go_router/go_router.dart';
import 'package:todo_app/features/todo/presentation/pages/splash_page.dart';
import 'package:todo_app/features/todo/presentation/pages/todo_page.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const TodoPage(),
    ),
  ],
);
