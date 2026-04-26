import 'package:flutter/material.dart';

class SwitchCaseExamplePage extends StatelessWidget {
  const SwitchCaseExamplePage({super.key});

  String getCode() {
    return r'''
void main() {
  int dia = 3;

  switch (dia) {
    case 1:
      print('Domingo');
      break;
    case 2:
      print('Segunda');
      break;
    case 3:
      print('Terça');
      break;
    case 4:
      print('Quarta');
      break;
    default:
      print('Outro dia');
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ConditionalTemplate(
      title: "SWITCH CASE",
      code: getCode(),
      explanation: """
A estrutura switch case é usada quando você quer comparar um valor com vários casos possíveis.

Exemplo:
switch (dia) {
  case 1:
    print('Domingo');
    break;
  ...
  default:
    print('Outro dia');
}

Ela deixa o código mais organizado quando existem muitos casos fixos.
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
