import 'package:flutter/material.dart';
import '../dart/dart_page.dart';
import '../flutter/flutter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Examples")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Dart"),
            subtitle: const Text("Exemplos da linguagem Dart"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DartPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Flutter"),
            subtitle: const Text("Exemplos de widgets e UI Flutter"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FlutterPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
