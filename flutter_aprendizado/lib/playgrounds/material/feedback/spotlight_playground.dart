import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class SpotlightPlayground extends StatefulWidget {
  const SpotlightPlayground({super.key});

  @override
  State<SpotlightPlayground> createState() => _SpotlightPlaygroundState();
}

class _SpotlightPlaygroundState extends State<SpotlightPlayground> {
  String title = 'Dica do dia';
  String message = 'Mantenha constÃ¢ncia nos treinos.';

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Spotlight',
      preview: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade400),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, size: 32, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(message),
                ],
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
        TextControl(
          label: 'Mensagem',
          initialValue: message,
          onChanged: (value) => setState(() => message = value),
        ),
      ],
    );
  }
}
