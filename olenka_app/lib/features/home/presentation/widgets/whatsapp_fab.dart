import 'package:flutter/material.dart';

/// FAB verde do WhatsApp. Na fase 2, plugamos url_launcher.
class WhatsappFab extends StatelessWidget {
  const WhatsappFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Abrir deep link wa.me com url_launcher
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp em breve')),
        );
      },
      backgroundColor: const Color(0xFF25D366),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.chat_bubble,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}