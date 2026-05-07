import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

const kOcorrenciasHeroTag = 'ocorrencias-label';

class OcorrenciasScreen extends StatelessWidget {
  const OcorrenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral0,
        appBar: AppBar(
          backgroundColor: AppColors.neutral0,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.brandGreen,
              size: 36,
            ),
            onPressed: () => context.go(AppRoutes.home),
          ),
          centerTitle: true,
          title: Hero(
            tag: kOcorrenciasHeroTag,
            flightShuttleBuilder:
                (context, animation, direction, fromCtx, toCtx) {
                  return FadeTransition(
                    opacity: animation,
                    child: toCtx.widget,
                  );
                },
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Relato de Ocorrência',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.headerBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.help_outline,
                color: AppColors.brandGreen,
                size: 34,
              ),
              onPressed: () => context.push(AppRoutes.ocorrenciasInfo),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 24),
            children: [
              const _SuspiciousIllustration(),
              const SizedBox(height: 36),
              Text(
                'Viu algo suspeito?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.headerBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Inicie um relato ao sofrer ou testemunhar uma ocorrência. Seu relato notificará imediatamente a Central 24h',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.headerBlue,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 150),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.headerBlue,
                    side: const BorderSide(
                      color: AppColors.brandGreen,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => context.push(AppRoutes.minhasOcorrencias),
                  icon: const Icon(Icons.assignment_outlined),
                  label: const Text(
                    'Meus relatos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => context.push(AppRoutes.ocorrenciasForm),
                  child: const Text(
                    'Iniciar relato',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuspiciousIllustration extends StatelessWidget {
  const _SuspiciousIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFDDF5E9),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x3327AE60), width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Lottie.asset(
            'assets/animations/call_center.json',
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
