import 'package:flutter/material.dart';

class TernaryOperatorExamplePage extends StatelessWidget {
  const TernaryOperatorExamplePage({super.key});

  String getCode() {
    return r'''
void main() {
  int idade = 18;

  String resultado = idade >= 18
      ? 'Maior de idade'
      : 'Menor de idade';

  print(resultado);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ConditionalTemplate(
      title: "Operador Ternário",
      code: getCode(),
      explanation: """
O operador ternário é uma forma curta de escrever uma condição com duas possibilidades.

Sintaxe:
condicao ? valorSeTrue : valorSeFalse

Exemplo:
idade >= 18 ? 'Maior de idade' : 'Menor de idade'
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
