import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConfig.appName)),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state.status) {
              HomeStatus.initial || HomeStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
              HomeStatus.failure => AppErrorView(
                  message: state.errorMessage ?? 'Erro inesperado.',
                ),
              HomeStatus.loaded => ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text(
                      'Home',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Mapa e cameras serao carregados nesta tela.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}