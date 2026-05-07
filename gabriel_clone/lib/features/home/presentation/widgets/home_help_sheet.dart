import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/app_colors.dart';

const homeCentralPhone = '5511984390687';

Future<void> showHomeHelpOptions(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.neutral0,
    barrierColor: Colors.black.withValues(alpha: 0.58),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HelpActionButton(
                label: 'Ligar para a Central 24h',
                color: const Color(0xFFC75C58),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _callCentral(context);
                },
              ),
              const SizedBox(height: 22),
              _HelpActionButton(
                label: 'Enviar mensagem para a Central 24h',
                color: const Color(0xFF319DCC),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _messageCentral(context);
                },
              ),
              const SizedBox(height: 18),
              _HelpActionButton(
                label: 'Cancelar',
                color: const Color(0xFF1595D3),
                fontWeight: FontWeight.w900,
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _callCentral(BuildContext context) async {
  final uri = Uri.parse('tel:$homeCentralPhone');
  final didLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!context.mounted || didLaunch) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Não foi possível iniciar a ligação para a Central 24h.'),
    ),
  );
}

Future<void> _messageCentral(BuildContext context) async {
  final message = Uri.encodeComponent(
    'Olá, preciso de ajuda da Central 24h pelo app Gabriel.',
  );
  final appUrl = Uri.parse('whatsapp://send?phone=$homeCentralPhone&text=$message');
  final webUrl = Uri.parse('https://wa.me/$homeCentralPhone?text=$message');

  if (await _tryLaunch(appUrl) || await _tryLaunch(webUrl)) {
    return;
  }

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Não foi possível abrir o WhatsApp da Central 24h.'),
    ),
  );
}

Future<bool> _tryLaunch(Uri uri) async {
  try {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

class _HelpActionButton extends StatelessWidget {
  const _HelpActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.fontWeight = FontWeight.w500,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: TextStyle(fontSize: 21, fontWeight: fontWeight),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
