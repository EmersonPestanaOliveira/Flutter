import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../network/network_connection_monitor.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({
    required this.monitor,
    required this.child,
    this.pendingStream,
    super.key,
  });

  final NetworkConnectionMonitor monitor;
  final Widget child;

  /// Stream opcional de itens pendentes de sync. Quando não nulo e com
  /// items > 0, exibe contador no banner de offline/poor.
  final Stream<List<PendingOcorrencia>>? pendingStream;

  // Mensagens base — mantidas iguais às originais (sem acento) para
  // compatibilidade com os testes existentes.
  static const _msgOffline =
      'Sem conexao com a internet. Algumas funcoes podem falhar.';
  static const _msgPoor =
      'Conexao instavel. O app pode demorar para responder.';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: monitor,
      builder: (context, _) {
        final isOffline =
            monitor.status == NetworkConnectionStatus.offline ||
            monitor.status == NetworkConnectionStatus.poor;

        if (!isOffline) {
          return Column(children: [Expanded(child: child)]);
        }

        final baseMessage = monitor.status == NetworkConnectionStatus.offline
            ? _msgOffline
            : _msgPoor;

        if (pendingStream == null) {
          return _buildWithBanner(context, baseMessage, null);
        }

        return StreamBuilder<List<PendingOcorrencia>>(
          stream: pendingStream,
          builder: (context, snapshot) {
            final pending = (snapshot.data ?? [])
                .where(
                  (p) =>
                      p.status == PendingStatus.queued.name ||
                      p.status == PendingStatus.syncing.name ||
                      p.status == PendingStatus.failed.name,
                )
                .length;
            return _buildWithBanner(
              context,
              baseMessage,
              pending > 0 ? pending : null,
            );
          },
        );
      },
    );
  }

  Widget _buildWithBanner(
    BuildContext context,
    String baseMessage,
    int? pendingCount,
  ) {
    final color = monitor.status == NetworkConnectionStatus.offline
        ? const Color(0xFFB3261E)
        : const Color(0xFF8A6D00);

    final message = pendingCount != null
        ? '$baseMessage $pendingCount relato${pendingCount > 1 ? 's' : ''} aguardando sync.'
        : baseMessage;

    return Column(
      children: [
        Material(
          color: color,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
