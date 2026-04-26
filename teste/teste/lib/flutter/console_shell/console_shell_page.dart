import 'package:flutter/material.dart';

class ConsoleShellPage extends StatelessWidget {
  const ConsoleShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Console Shell'),
      ),
      body: const Center(
        child: Text(
          'Console Shell',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
