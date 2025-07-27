import 'package:flutter/material.dart';
import '../data/clients_model.dart';

class ClientsProfilePage extends StatelessWidget {
  final ClientModel client;

  const ClientsProfilePage({super.key, required this.client});

  String formatBirthday(DateTime? date) {
    if (date == null) return 'Não informado';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Text(
                  client.name.isNotEmpty
                      ? client.name.substring(0, 1).toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Nome:', style: labelStyle),
            Text(client.name, style: valueStyle),
            const SizedBox(height: 16),

            Text('Telefone:', style: labelStyle),
            Text(client.phone, style: valueStyle),
            const SizedBox(height: 16),

            Text('Email:', style: labelStyle),
            Text(
              client.email.isNotEmpty ? client.email : 'Não informado',
              style: valueStyle,
            ),
            const SizedBox(height: 16),

            Text('Data de Aniversário:', style: labelStyle),
            Text(formatBirthday(client.birthday), style: valueStyle),
            const SizedBox(height: 16),

            Text('Redes Sociais:', style: labelStyle),
            Text(
              (client.social?.isNotEmpty ?? false)
                  ? client.social!
                  : 'Não informado',
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get labelStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  TextStyle get valueStyle =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
}
