import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../data/services/ocorrencia_service.dart';

class OcorrenciaInfoScreen extends StatelessWidget {
  const OcorrenciaInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.brandGreen,
            size: 36,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Informações sobre Ocorrências',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder<List<OcorrenciaInfoSection>>(
        future: OcorrenciaService().fetchInfoSections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoadingIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  BackendErrorMapper.message(snapshot.error!),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final sections = snapshot.data ?? const [];
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(30, 46, 30, 30),
            itemCount: sections.length,
            separatorBuilder: (context, index) => const SizedBox(height: 34),
            itemBuilder: (context, index) {
              final section = sections[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.headerBlue,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    section.body,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.neutral600,
                      height: 1.45,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
