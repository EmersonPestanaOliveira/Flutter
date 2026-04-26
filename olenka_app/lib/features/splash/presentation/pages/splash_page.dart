import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/widgets/loadings/dots_loader.dart';
import '../../../auth/data/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
    _boot();
  }

  Future<void> _boot() async {
    // Espera AO MESMO TEMPO: o minimo de 2s E o warm-up do cache.
    // Future.wait garante que nenhum dos dois fica para tras.
    final user = AuthService.instance.currentUser;

    await Future.wait<void>([
      Future<void>.delayed(const Duration(milliseconds: 2000)),
      if (user != null) warmUpBiometricCache(user.uid),
    ]);

    if (!mounted) return;

    final loggedIn = AuthService.instance.currentUser != null;
    // Nao escolhemos aqui se vai pra /unlock ou /home.
    // Apenas dizemos "vai pra home" e o redirect do router decide
    // se manda pra /unlock caso a biometria esteja ativa.
    context.go(loggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/logo.webp',
                        width: 240,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: AppSpacing.xxxl * 1.5),
                      const DotsLoader(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
