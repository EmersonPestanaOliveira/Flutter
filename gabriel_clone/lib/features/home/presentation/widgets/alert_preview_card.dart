import 'package:flutter/material.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';

class AlertPreviewCard extends StatelessWidget {
  const AlertPreviewCard({
    required this.alerta,
    required this.onClose,
    this.onRetry,
    super.key,
  });

  final Alerta alerta;
  final VoidCallback onClose;
  final Future<void> Function(String clientId)? onRetry;

  @override
  Widget build(BuildContext context) {
    final offlineStatus = _OfflineStatusInfo.from(alerta.localSyncStatus);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 18, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(alerta: alerta, onClose: onClose),
            const SizedBox(height: 8),
            Text(
              alerta.tipo.label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF06295C),
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              alerta.descricao,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF666666),
                fontSize: 18,
                height: 1.25,
              ),
            ),
            if (offlineStatus != null) ...[
              const SizedBox(height: 14),
              _OfflineStatusRow(
                status: offlineStatus,
                clientId: alerta.clientId,
                onRetry: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.alerta, required this.onClose});

  final Alerta alerta;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${_locationText(alerta)} | ${_formatDate(alerta.data)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF666666),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: onClose,
        ),
      ],
    );
  }
}

class _OfflineStatusRow extends StatelessWidget {
  const _OfflineStatusRow({
    required this.status,
    required this.clientId,
    required this.onRetry,
  });

  final _OfflineStatusInfo status;
  final String? clientId;
  final Future<void> Function(String clientId)? onRetry;

  @override
  Widget build(BuildContext context) {
    final canRetry =
        status.canRetry &&
        onRetry != null &&
        clientId != null &&
        clientId!.trim().isNotEmpty;
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: status.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, size: 15, color: status.foregroundColor),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: status.foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canRetry)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF06295C),
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Tentar novamente'),
            onPressed: () {
              onRetry?.call(clientId!.trim());
            },
          ),
      ],
    );
  }
}

class _OfflineStatusInfo {
  const _OfflineStatusInfo({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.canRetry,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool canRetry;

  static _OfflineStatusInfo? from(String? status) {
    switch (status) {
      case 'queued':
        return const _OfflineStatusInfo(
          label: 'Pendente de envio',
          icon: Icons.schedule,
          foregroundColor: Color(0xFF6B4F00),
          backgroundColor: Color(0xFFFFF5CC),
          canRetry: false,
        );
      case 'syncing':
        return const _OfflineStatusInfo(
          label: 'Enviando...',
          icon: Icons.sync,
          foregroundColor: Color(0xFF064E7A),
          backgroundColor: Color(0xFFDFF3FF),
          canRetry: false,
        );
      case 'synced':
        return const _OfflineStatusInfo(
          label: 'Sincronizado',
          icon: Icons.check_circle,
          foregroundColor: Color(0xFF116329),
          backgroundColor: Color(0xFFDFF7E7),
          canRetry: false,
        );
      case 'failed':
        return const _OfflineStatusInfo(
          label: 'Falha ao enviar',
          icon: Icons.error_outline,
          foregroundColor: Color(0xFF8A1C1C),
          backgroundColor: Color(0xFFFFE1E1),
          canRetry: true,
        );
      case 'deadLetter':
        return const _OfflineStatusInfo(
          label: 'Precisa de ação',
          icon: Icons.report_problem_outlined,
          foregroundColor: Color(0xFF7A2E0E),
          backgroundColor: Color(0xFFFFE8D5),
          canRetry: true,
        );
      case 'waitingRetry':
        return const _OfflineStatusInfo(
          label: 'Aguardando nova tentativa',
          icon: Icons.hourglass_bottom,
          foregroundColor: Color(0xFF5E4B00),
          backgroundColor: Color(0xFFFFF2B8),
          canRetry: false,
        );
    }
    return null;
  }
}

String _locationText(Alerta alerta) {
  if (alerta.bairro.isNotEmpty && alerta.cidade.isNotEmpty) {
    return '${alerta.bairro}, ${alerta.cidade}';
  }
  if (alerta.bairro.isNotEmpty) {
    return alerta.bairro;
  }
  return alerta.cidade;
}

String _formatDate(DateTime date) {
  if (date.millisecondsSinceEpoch == 0) {
    return '--/--/----';
  }
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
