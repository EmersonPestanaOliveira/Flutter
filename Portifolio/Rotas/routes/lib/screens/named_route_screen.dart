import 'package:flutter/material.dart';

class NamedRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rotas Nomeadas')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/simple'),
          child: Text('Ir para Navegação Simples'),
        ),
      ),
    );
  }
}
