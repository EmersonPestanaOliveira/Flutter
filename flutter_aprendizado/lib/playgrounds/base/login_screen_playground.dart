import 'package:flutter/material.dart';
import '../../widgets/playground/control_widgets.dart';
import '../../widgets/playground/playground_page.dart';

class LoginScreenPlayground extends StatefulWidget {
  const LoginScreenPlayground({super.key});

  @override
  State<LoginScreenPlayground> createState() => _LoginScreenPlaygroundState();
}

class _LoginScreenPlaygroundState extends State<LoginScreenPlayground> {
  String title = 'Login';
  bool showSubtitle = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Login Screen',
      preview: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showSubtitle) ...[
              const SizedBox(height: 8),
              const Text('Entre para continuar'),
            ],
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                child: Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
      controls: [
        TextControl(
          label: 'TÃ­tulo',
          initialValue: title,
          onChanged: (value) => setState(() => title = value),
        ),
        SwitchListTile(
          title: const Text('Mostrar subtÃ­tulo'),
          value: showSubtitle,
          onChanged: (value) => setState(() => showSubtitle = value),
        ),
      ],
    );
  }
}
