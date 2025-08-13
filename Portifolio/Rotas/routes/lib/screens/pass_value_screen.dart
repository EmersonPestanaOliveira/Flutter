import 'package:flutter/material.dart';

class PassValueScreen extends StatelessWidget {
  final String data;

  const PassValueScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Passando Valores')),
      body: Center(
        child: Text('Valor recebido: $data'),
      ),
    );
  }
}
