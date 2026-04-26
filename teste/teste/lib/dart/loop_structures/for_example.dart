import 'package:flutter/material.dart';

class ForExamplePage extends StatelessWidget {
  const ForExamplePage({super.key});

  String getCode() {
    return r'''
void main() {

  for (int i = 0; i < 5; i++) {
    print("Número: $i");
  }

}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _LoopTemplate(
      title: "FOR",
      code: getCode(),
      explanation: """
O loop for é usado quando sabemos quantas vezes queremos repetir.

Sintaxe:
for (inicialização; condição; incremento)

Exemplo:
for (int i = 0; i < 5; i++) {
  print(i);
}
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
                  fontSize: 14,
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
