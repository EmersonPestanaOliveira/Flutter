import 'package:flutter/material.dart';

class IfElseIfElseExamplePage extends StatelessWidget {
  const IfElseIfElseExamplePage({super.key});

  String getCode() {
    return r'''
void main() {
  int nota = 75;

  if (nota >= 90) {
    print('Excelente');
  } else if (nota >= 70) {
    print('Bom');
  } else if (nota >= 50) {
    print('Regular');
  } else {
    print('Reprovado');
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ConditionalTemplate(
      title: "IF - ELSE IF - ELSE",
      code: getCode(),
      explanation: """
Essa estrutura é usada quando existem várias condições.

Exemplo:
if (nota >= 90) {
  ...
} else if (nota >= 70) {
  ...
} else {
  ...
}

O Dart testa as condições em ordem e executa apenas o primeiro bloco verdadeiro.
""",
    );
  }
}

class _ConditionalTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _ConditionalTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
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
}
