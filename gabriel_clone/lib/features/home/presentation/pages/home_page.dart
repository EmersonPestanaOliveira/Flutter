import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_button.dart';
import '../../../../core/design_system/components/app_error_widget.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConfig.appName,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state.status) {
            HomeStatus.initial || HomeStatus.loading =>
              const AppLoadingIndicator(),
            HomeStatus.failure => AppErrorWidget(
                message: state.errorMessage ?? 'Erro inesperado.',
                onRetry: context.read<HomeCubit>().loadCameraLocations,
              ),
            HomeStatus.loaded => ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Gravar e ler teste',
                    onPressed: state.isTestingFirestore
                        ? null
                        : context
                            .read<HomeCubit>()
                            .createAndReadFirestoreTestDocument,
                    leadingIcon: Icons.cloud_done_outlined,
                    isLoading: state.isTestingFirestore,
                  ),
                  if (state.hasFirestoreTestDocument) ...[
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: 'Remover teste',
                      onPressed: state.isTestingFirestore
                          ? null
                          : context
                              .read<HomeCubit>()
                              .deleteFirestoreTestDocument,
                      variant: AppButtonVariant.secondary,
                      leadingIcon: Icons.delete_outline,
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
    );
  }
}