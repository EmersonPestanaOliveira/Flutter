import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';

class SnackBarPlayground extends StatefulWidget {
  const SnackBarPlayground({super.key});

  @override
  State<SnackBarPlayground> createState() => _SnackBarPlaygroundState();
}

class _SnackBarPlaygroundState extends State<SnackBarPlayground> {
  String message = 'Exemplo de SnackBar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: const Text('Mostrar SnackBar'),
            ),
            const SizedBox(height: 24),
            TextControl(
              label: 'Mensagem',
              initialValue: message,
              onChanged: (value) {
                setState(() {
                  message = value.isEmpty ? 'Exemplo de SnackBar' : value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
