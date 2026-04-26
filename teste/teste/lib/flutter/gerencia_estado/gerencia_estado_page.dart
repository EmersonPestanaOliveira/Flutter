import 'package:flutter/material.dart';

class GerenciaEstadoPage extends StatelessWidget {
  const GerenciaEstadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GerÃªncia de estado'),
      ),
      body: const Center(
        child: Text(
          'GerÃªncia de estado',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
