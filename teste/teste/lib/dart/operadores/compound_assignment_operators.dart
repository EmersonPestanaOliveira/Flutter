import 'package:flutter/material.dart';

class CompoundAssignmentOperatorsPage extends StatelessWidget {
  const CompoundAssignmentOperatorsPage({super.key});

  String getCode() {
    return r'''
void main() {
  int x = 10;

  x += 5;
  x -= 2;
  x *= 3;
  x ~/= 2;
  x %= 4;

  print(x);

  String? nome;
  nome ??= 'Ana';
  print(nome);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _Template(
      title: "Atribuição Combinada",
      code: getCode(),
      explanation:
          "Combina atribuição com outra operação, como soma, subtração, multiplicação, divisão e atribuição nula.",
    );
  }
}

class _Template extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _Template({
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
