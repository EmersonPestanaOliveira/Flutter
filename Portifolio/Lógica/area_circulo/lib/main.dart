import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculoAreaCirculoApp());
}

class CalculoAreaCirculoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo da Área do Círculo',
      home: CalculoAreaScreen(),
    );
  }
}

class CalculoAreaScreen extends StatefulWidget {
  @override
  _CalculoAreaScreenState createState() => _CalculoAreaScreenState();
}

class _CalculoAreaScreenState extends State<CalculoAreaScreen> {
  final TextEditingController _raioController = TextEditingController();
  String _resultado = '';
  double _raio = 0.0;

  void _calcularArea() {
    try {
      double raio = double.parse(_raioController.text);
      double area = pi * pow(raio, 2);
      setState(() {
        _raio = raio;
        _resultado = 'Área: ${area.toStringAsFixed(4)}';
      });
    } catch (e) {
      setState(() {
        _resultado = 'Entrada inválida!';
        _raio = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo da Área do Círculo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _raioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o raio do círculo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calcularArea,
              child: Text('Calcular Área'),
            ),
            SizedBox(height: 16),
            Text(
              _resultado,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            if (_raio > 0)
              Center(
                child: CustomPaint(
                  size: Size(200, 200), // Ajuste o tamanho do círculo
                  painter: CirclePainter(_raio),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double raio;

  CirclePainter(this.raio);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    // Desenha o círculo
    double scaledRaio =
        min(size.width, size.height) / 2 - 10; // Escalado para caber na tela
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, scaledRaio, circlePaint);

    // Desenha a linha do centro ao perímetro
    Offset endPoint = Offset(center.dx + scaledRaio, center.dy);
    canvas.drawLine(center, endPoint, linePaint);

    // Adiciona o texto "raio = valor" acima da linha e dentro do círculo
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'raio = ${raio.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Posiciona o texto acima da linha e dentro do círculo
    double textX = center.dx + scaledRaio / 2 - textPainter.width / 2;
    double textY = center.dy - 10; // Acima da linha
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
