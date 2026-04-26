import 'package:flutter/material.dart';

class CascadeOperatorsPage extends StatelessWidget {
  const CascadeOperatorsPage({super.key});

  String getCode() {
    return r'''
class Pessoa {
  String nome = '';
  int idade = 0;

  void mostrar() {
    print('$nome - $idade');
  }
}

void main() {
  var pessoa = Pessoa()
    ..nome = 'Ana'
    ..idade = 20
    ..mostrar();

  Pessoa? outraPessoa;
  outraPessoa
    ?..nome = 'Carlos'
    ..idade = 30
    ..mostrar();
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _Template(
      title: "Operadores Cascata",
      code: getCode(),
      explanation:
          "Os operadores cascata permitem fazer várias operações no mesmo objeto em sequência.",
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
