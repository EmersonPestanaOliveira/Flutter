import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';

class NotifierPlayground extends StatefulWidget {
  const NotifierPlayground({super.key});

  @override
  State<NotifierPlayground> createState() => _NotifierPlaygroundState();
}

class _NotifierPlaygroundState extends State<NotifierPlayground> {
  String title = 'Novo treino disponÃ­vel';
  String message = 'Seu plano foi atualizado.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                title: Text(title),
                subtitle: Text(message),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 24),
            TextControl(
              label: 'TÃ­tulo',
              initialValue: title,
              onChanged: (value) => setState(() => title = value),
            ),
            TextControl(
              label: 'Mensagem',
              initialValue: message,
              onChanged: (value) => setState(() => message = value),
            ),
          ],
        ),
      ),
    );
  }
}
