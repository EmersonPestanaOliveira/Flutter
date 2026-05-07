import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/ocorrencia_report.dart';
import '../../domain/enums/ocorrencia_status.dart';
import '../../domain/usecases/watch_my_ocorrencias_usecase.dart';

class MinhasOcorrenciasScreen extends StatelessWidget {
  const MinhasOcorrenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.brandGreen, size: 36),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Meus relatos',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder<List<PendingOcorrencia>>(
        stream: sl<WatchPendingOcorrenciasUseCase>().call(),
        builder: (context, pendingSnapshot) {
          final pendingItems = pendingSnapshot.data ?? const [];
          return StreamBuilder<List<OcorrenciaReport>>(
            stream: sl<WatchMyOcorrenciasUseCase>().call(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  pendingItems.isEmpty) {
                return const AppLoadingIndicator();
              }
              if (snapshot.hasError) {
                return const _EmptyState(
                  icon: Icons.error_outline,
                  title: 'Erro ao carregar relatos.',
                );
              }
              final reports = [...?snapshot.data]
                ..sort((a, b) {
                  final ad = a.createdAt;
                  final bd = b.createdAt;
                  return (bd ?? DateTime(0)).compareTo(ad ?? DateTime(0));
                });
              final syncedIds = reports.map((r) => r.id).toSet();
              final visiblePending = pendingItems
                  .where((p) => !syncedIds.contains(p.clientId))
                  .toList();
              if (reports.isEmpty && visiblePending.isEmpty) {
                return const _EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Você ainda não enviou relatos.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: visiblePending.length + reports.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index < visiblePending.length) {
                    final pending = visiblePending[index];
                    return _PendingCard(
                      item: pending,
                      onRetry: () => sl<RetryFailedOcorrenciaUseCase>().call(pending.clientId),
                    );
                  }
                  return _ReportCard(report: reports[index - visiblePending.length]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.item, required this.onRetry});
  final PendingOcorrencia item;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(item.createdAt);
    final shortId = item.clientId.length > 8 ? item.clientId.substring(0, 8) : item.clientId;
    final status = OcorrenciaStatusX.fromLocalQueueStatus(item.status);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text('Relato #$shortId',
                  style: const TextStyle(color: AppColors.headerBlue, fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            _StatusPill(label: status.label, status: status),
          ]),
          const SizedBox(height: AppSpacing.md),
          Text('Criado em: ${_fmtDate(createdAt)}',
              style: const TextStyle(color: AppColors.neutral600)),
          if (item.attemptCount > 0 && status != OcorrenciaStatus.syncing) ...[
            const SizedBox(height: AppSpacing.xs),
            Text('Tentativas: ${item.attemptCount} / ${PendingOcorrenciasDao.maxAttempts}',
                style: const TextStyle(color: AppColors.neutral600, fontSize: 12)),
          ],
          if (status.isRetryable) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Tentar novamente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brandGreen,
                  side: const BorderSide(color: AppColors.brandGreen),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final OcorrenciaReport report;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(
                'Relato #${report.id.length > 6 ? report.id.substring(0, 6) : report.id}',
                style: const TextStyle(color: AppColors.headerBlue, fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            _StatusPill(label: report.status.label, status: report.status),
          ]),
          const SizedBox(height: AppSpacing.md),
          Text('Ocorrência: ${_fmtDate(report.quando)} às ${report.horario}',
              style: const TextStyle(color: AppColors.headerBlue, fontWeight: FontWeight.w700)),
          if (report.createdAt != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text('Enviado em: ${_fmtDate(report.createdAt!)}',
                style: const TextStyle(color: AppColors.neutral600)),
          ],
          if (report.informacoes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(report.informacoes,
                maxLines: 3, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.neutral800, height: 1.35)),
          ],
          if (report.isPublished) ...[
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              const Icon(Icons.public, size: 14, color: AppColors.brandGreen),
              const SizedBox(width: 4),
              const Text('Publicado no mapa comunitário',
                  style: TextStyle(color: AppColors.brandGreen, fontSize: 12, fontWeight: FontWeight.w700)),
            ]),
          ],
        ],
      ),
    );
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '--/--/----';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutral100),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.status});
  final String label;
  final OcorrenciaStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      OcorrenciaStatus.syncing => (AppColors.brandGreen, Icons.sync),
      OcorrenciaStatus.uploadFailed => (AppColors.accentRed, Icons.error_outline),
      OcorrenciaStatus.deadLetter => (AppColors.accentRed, Icons.block),
      OcorrenciaStatus.publicado => (AppColors.brandGreen, Icons.check_circle_outline),
      OcorrenciaStatus.rejeitado => (AppColors.accentRed, Icons.cancel_outlined),
      OcorrenciaStatus.concluido => (AppColors.brandGreen, Icons.done_all),
      OcorrenciaStatus.emAnalise || OcorrenciaStatus.pendingReview =>
        (AppColors.warning, Icons.hourglass_empty),
      _ => (AppColors.warning, Icons.schedule),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.neutral300, size: 54),
          const SizedBox(height: AppSpacing.lg),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.headerBlue, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}
