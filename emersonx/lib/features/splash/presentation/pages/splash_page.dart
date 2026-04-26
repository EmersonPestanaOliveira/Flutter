import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..initialize(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();
  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashReady) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.dark900 : AppColors.white,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: _LogoWidget(color: scheme.primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Nome do app
                    Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          children: [
                            Text(
                              'EmersonX',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Flutter Portfolio',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.neutral400
                                    : AppColors.neutral600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // Loading
                    BlocBuilder<SplashCubit, SplashState>(
                      builder: (context, state) {
                        return AnimatedOpacity(
                          opacity: state is SplashLoading ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                              backgroundColor: isDark
                                  ? AppColors.dark600
                                  : AppColors.neutral200,
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Logo desenhado com CustomPainter - sem dependencia de asset
class _LogoWidget extends StatelessWidget {
  const _LogoWidget({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(56, 56),
          painter: _ExLogoPainter(color: color),
        ),
      ),
    );
  }
}

class _ExLogoPainter extends CustomPainter {
  const _ExLogoPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Letra E
    final ePath = Path()
      ..moveTo(w * 0.05, h * 0.1)
      ..lineTo(w * 0.05, h * 0.9)
      ..moveTo(w * 0.05, h * 0.1)
      ..lineTo(w * 0.38, h * 0.1)
      ..moveTo(w * 0.05, h * 0.5)
      ..lineTo(w * 0.32, h * 0.5)
      ..moveTo(w * 0.05, h * 0.9)
      ..lineTo(w * 0.38, h * 0.9);
    canvas.drawPath(ePath, paint);

    // Letra X
    final xPaint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(w * 0.52, h * 0.1),
      Offset(w * 0.95, h * 0.9),
      xPaint,
    );
    canvas.drawLine(
      Offset(w * 0.95, h * 0.1),
      Offset(w * 0.52, h * 0.9),
      xPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}