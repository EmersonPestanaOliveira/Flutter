import 'package:flutter/material.dart';

class ArithmeticOperatorsPage extends StatelessWidget {
  const ArithmeticOperatorsPage({super.key});

  String getCode() {
    return r'''
void main() {
  int a = 10;
  int b = 3;

  print(a + b);
  print(a - b);
  print(a * b);
  print(a / b);
  print(a ~/ b);
  print(a % b);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _OperatorTemplate(
      title: "Aritméticos",
      code: getCode(),
      explanation:
          "Operadores aritméticos realizam soma, subtração, multiplicação, divisão, divisão inteira e resto.",
    );
  }
}

class _OperatorTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _OperatorTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPage(title, code, explanation);
  }
}

Widget _buildPage(String title, String code, String explanation) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Código Dart:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "monospace",
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Explicação:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(explanation, style: const TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}
