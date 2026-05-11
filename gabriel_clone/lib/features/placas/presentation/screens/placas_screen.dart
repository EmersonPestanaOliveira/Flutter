import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

const kPlacasHeroTag = 'placas-label';

class PlacasScreen extends StatelessWidget {
  const PlacasScreen({super.key});

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
            tag: kPlacasHeroTag,
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
                'Busque seu veículo',
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
              onPressed: () => context.push(AppRoutes.placasInfo),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 24),
            children: [
              Lottie.asset(
                'assets/animations/placas.json',
                fit: BoxFit.contain,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 44),
              Text(
                'Gostaria de poder buscar o seu veículo pela nossa Área de Proteção?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.headerBlue,
                  fontSize: 24,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Adicione a placa do seu veículo furtado ou roubado ao reconhecimento de placas da Gabriel e localize-o caso transite pela nossa Área de Proteção.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.headerBlue,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Funcionalidade disponível apenas para clientes do Camaleão 2. Clique no botão abaixo e contrate.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.headerBlue,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF08C779),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => context.push(AppRoutes.placasForm),
                  child: const Text(
                    'Quero contratar Camaleão 2',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
