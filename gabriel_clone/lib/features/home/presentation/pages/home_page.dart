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
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: state.isTestingFirestore
                          ? null
                          : context
                              .read<HomeCubit>()
                              .createAndReadFirestoreTestDocument,
                      icon: state.isTestingFirestore
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_done_outlined),
                      label: const Text('Gravar e ler teste'),
                    ),
                    if (state.hasFirestoreTestDocument) ...[
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: state.isTestingFirestore
                            ? null
                            : context
                                .read<HomeCubit>()
                                .deleteFirestoreTestDocument,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remover teste'),
                      ),
                    ],
                    if (state.firestoreValidationMessage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        state.firestoreValidationMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}