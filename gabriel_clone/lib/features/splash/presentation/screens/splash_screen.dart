import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
    _navigationTimer = Timer(const Duration(milliseconds: 1800), _finishSplash);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _finishSplash() {
    if (!mounted) {
      return;
    }

    final route = FirebaseAuth.instance.currentUser == null
        ? AppRoutes.login
        : AppRoutes.home;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.headerBlue,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xB3001022),
                    Color(0x26001022),
                    Color(0xD9001022),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 48, 30, 34),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        const _GabrielLogoLockup(),
                        const Spacer(flex: 3),
                        const _SplashTagline(),
                        const SizedBox(height: 54),
                        const _SplashBenefits(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GabrielLogoLockup extends StatelessWidget {
  const _GabrielLogoLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_vazado.webp',
          width: 106,
          height: 106,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'gabriel',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.neutral0,
            fontSize: 56,
            height: 0.95,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'CÂMERAS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.accentRed,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(width: 126, height: 2, color: AppColors.accentRed),
        const SizedBox(height: AppSpacing.md),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              color: AppColors.neutral0,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
            children: [
              TextSpan(text: '+ PROTEÇÃO '),
              TextSpan(
                text: '24h',
                style: TextStyle(color: AppColors.accentRed),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SplashTagline extends StatelessWidget {
  const _SplashTagline();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              color: AppColors.neutral0,
              fontSize: 21,
              height: 1.4,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
            ),
            children: [
              TextSpan(text: 'TECNOLOGIA\nQUE '),
              TextSpan(
                text: 'PROTEGE.',
                style: TextStyle(color: AppColors.accentRed),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(width: 74, height: 2, color: AppColors.accentRed),
      ],
    );
  }
}

class _SplashBenefits extends StatelessWidget {
  const _SplashBenefits();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SplashBenefit(
            icon: Icons.verified_user_outlined,
            label: 'SEGURANÇA\nINTELIGENTE',
          ),
        ),
        _SplashDivider(),
        Expanded(
          child: _SplashBenefit(
            icon: Icons.history_toggle_off,
            label: 'PROTEÇÃO\n24 HORAS',
          ),
        ),
        _SplashDivider(),
        Expanded(
          child: _SplashBenefit(
            icon: Icons.phone_iphone,
            label: 'CONECTADO\nCOM VOCÊ',
          ),
        ),
      ],
    );
  }
}

class _SplashBenefit extends StatelessWidget {
  const _SplashBenefit({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.neutral0, size: 38),
        const SizedBox(height: AppSpacing.md),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.neutral0,
            fontSize: 11,
            height: 1.25,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }
}

class _SplashDivider extends StatelessWidget {
  const _SplashDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: const Color(0x80FFFFFF),
    );
  }
}
