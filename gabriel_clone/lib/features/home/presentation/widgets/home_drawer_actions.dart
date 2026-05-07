import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/di/injection_container.dart';

void goFromHomeDrawer(BuildContext context, String route) {
  final router = GoRouter.of(context);
  Navigator.of(context).pop();
  router.push(route);
}

Future<void> openTechnicalSupport(BuildContext context) async {
  Navigator.of(context).pop();
  final messenger = ScaffoldMessenger.of(context);
  final appUrl = Uri.parse('whatsapp://send?phone=5511984390687');
  final webUrl = Uri.parse('https://wa.me/5511984390687');

  if (await _tryLaunch(appUrl) || await _tryLaunch(webUrl)) {
    return;
  }

  if (!context.mounted) {
    return;
  }
  messenger.showSnackBar(
    const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
  );
}

Future<void> confirmHomeLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Sair do app'),
        content: const Text('Deseja encerrar sua sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair'),
          ),
        ],
      );
    },
  );

  if (!context.mounted || shouldLogout != true) {
    return;
  }

  await sl<AuthService>().signOut();
}

Future<bool> _tryLaunch(Uri uri) async {
  try {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
