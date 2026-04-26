import 'package:flutter/material.dart';
import '../../widgets/playground/control_widgets.dart';
import '../../widgets/playground/playground_page.dart';

class ProfileScreenPlayground extends StatefulWidget {
  const ProfileScreenPlayground({super.key});

  @override
  State<ProfileScreenPlayground> createState() =>
      _ProfileScreenPlaygroundState();
}

class _ProfileScreenPlaygroundState extends State<ProfileScreenPlayground> {
  String name = 'Seu Nome';
  String bio = 'Sua bio aqui';

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Profile Screen',
      preview: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bio,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Card(
              child: ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Treinos'),
                subtitle: Text('12 concluÃ­dos'),
              ),
            ),
          ],
        ),
      ),
      controls: [
        TextControl(
          label: 'Nome',
          initialValue: name,
          onChanged: (value) => setState(() => name = value),
        ),
        TextControl(
          label: 'Bio',
          initialValue: bio,
          onChanged: (value) => setState(() => bio = value),
        ),
      ],
    );
  }
}
