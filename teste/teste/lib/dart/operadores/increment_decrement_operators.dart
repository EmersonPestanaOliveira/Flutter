import 'package:flutter/material.dart';

class IncrementDecrementOperatorsPage extends StatelessWidget {
  const IncrementDecrementOperatorsPage({super.key});

  String getCode() {
    return r'''
void main() {
  int x = 10;

  print(++x);
  print(x++);
  print(x);

  print(--x);
  print(x--);
  print(x);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _IncrementTemplate(
      title: "Incremento e Decremento",
      code: getCode(),
      explanation:
          "Os operadores ++ e -- aumentam ou diminuem o valor em 1. Podem ser prefixados ou pós-fixados.",
    );
  }
}

class _IncrementTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _IncrementTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) => _buildPage(title, code, explanation);
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
