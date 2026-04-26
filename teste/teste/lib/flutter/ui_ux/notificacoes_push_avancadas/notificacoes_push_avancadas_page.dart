import 'package:flutter/material.dart';

class NotificacoesPushAvancadasPagePage extends StatelessWidget {
  const NotificacoesPushAvancadasPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificacoes Push Avancadas'),
      ),
      body: const Center(
        child: Text(
          'Notificacoes Push Avancadas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
