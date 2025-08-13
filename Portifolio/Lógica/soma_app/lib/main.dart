import 'package:flutter/material.dart';

void main() {
  runApp(SomaApp());
}

class SomaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Soma',
      home: SomaScreen(),
    );
  }
}

class SomaScreen extends StatefulWidget {
  @override
  _SomaScreenState createState() => _SomaScreenState();
}

class _SomaScreenState extends State<SomaScreen> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _resultado = '';

  void _calcularSoma() {
    try {
      int a = int.parse(_controllerA.text);
      int b = int.parse(_controllerB.text);
      setState(() {
        _resultado = 'Soma: ${a + b}';
      });
    } catch (e) {
      setState(() {
        _resultado = 'Entrada inválida!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Soma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerA,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o primeiro número',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controllerB,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o segundo número',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calcularSoma,
              child: Text('Calcular Soma'),
            ),
            SizedBox(height: 16),
            Text(
              _resultado,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
