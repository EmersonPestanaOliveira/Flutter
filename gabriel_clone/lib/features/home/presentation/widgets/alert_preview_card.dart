import 'package:flutter/material.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';

class AlertPreviewCard extends StatelessWidget {
  const AlertPreviewCard({
    required this.alerta,
    required this.onClose,
    super.key,
  });

  final Alerta alerta;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
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
