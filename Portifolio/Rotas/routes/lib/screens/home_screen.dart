import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navegação e Rotas')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Navegação Simples'),
            onTap: () => Navigator.pushNamed(context, '/simple'),
          ),
          ListTile(
            title: Text('Passando Valores entre Telas'),
            onTap: () => Navigator.pushNamed(context, '/pass-value'),
          ),
          ListTile(
            title: Text('Rotas Nomeadas'),
            onTap: () => Navigator.pushNamed(context, '/named-route'),
          ),
          ListTile(
            title: Text('Abas'),
            onTap: () => Navigator.pushNamed(context, '/tabs'),
          ),
        ],
      ),
    );
  }
}
