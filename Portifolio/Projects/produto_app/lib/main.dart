import 'package:flutter/material.dart';

void main() {
  runApp(ProdutoSimplesApp());
}

class ProdutoSimplesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produto Simples',
      home: ProdutoSimplesScreen(),
    );
  }
}

class ProdutoSimplesScreen extends StatefulWidget {
  @override
  _ProdutoSimplesScreenState createState() => _ProdutoSimplesScreenState();
}

class _ProdutoSimplesScreenState extends State<ProdutoSimplesScreen> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _resultado = '';

  void _calcularProduto() {
    try {
      int a = int.parse(_controllerA.text);
      int b = int.parse(_controllerB.text);
      int produto = a * b;

      setState(() {
        _resultado = 'Produto: $produto';
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
        title: Text('Produto Simples'),
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
                labelText: 'Digite o primeiro valor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controllerB,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o segundo valor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calcularProduto,
              child: Text('Calcular Produto'),
            ),
            SizedBox(height: 16),
            Text(
              "${_controllerA.text} X ${_controllerB.text}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
