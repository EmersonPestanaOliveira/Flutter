import 'package:flutter/material.dart';

class ForEachExamplePage extends StatelessWidget {
  const ForEachExamplePage({super.key});

  String getCode() {
    return r'''
void main() {

  var lista = [1, 2, 3, 4];

  lista.forEach((numero) {
    print(numero);
  });

}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _LoopTemplate(
      title: "forEach em uma lista",
      code: getCode(),
      explanation: """
O forEach percorre elementos de uma coleção executando uma função.

Exemplo:
lista.forEach((numero) {
  print(numero);
});
""",
    );
  }
}

class _LoopTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _LoopTemplate({
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
