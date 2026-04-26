import 'package:flutter/material.dart';

class IfElseExamplePage extends StatelessWidget {
  const IfElseExamplePage({super.key});

  String getCode() {
    return r'''
void main() {
  int idade = 16;

  if (idade >= 18) {
    print('Maior de idade');
  } else {
    print('Menor de idade');
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ConditionalTemplate(
      title: "IF ELSE",
      code: getCode(),
      explanation: """
A estrutura if else permite escolher entre dois blocos.

Exemplo:
if (idade >= 18) {
  print('Maior de idade');
} else {
  print('Menor de idade');
}

Se a condição for true, executa o if.
Se for false, executa o else.
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
