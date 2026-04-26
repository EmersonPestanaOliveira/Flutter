import 'package:flutter/material.dart';

class ConstrutoresPage extends StatelessWidget {
  const ConstrutoresPage({super.key});

  String getCode() {
    return r'''
class Pessoa {
  String nome;
  int idade;

  Pessoa(this.nome, this.idade);

  Pessoa.nomeada(this.nome) : idade = 0;

  factory Pessoa.bebe(String nome) {
    return Pessoa(nome, 0);
  }

  @override
  String toString() => '$nome - $idade';
}

void main() {
  var p1 = Pessoa('Ana', 25);
  var p2 = Pessoa.nomeada('Carlos');
  var p3 = Pessoa.bebe('Bia');

  print(p1);
  print(p2);
  print(p3);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ClassTemplate(
      title: "Construtores",
      code: getCode(),
      explanation:
          "Construtores inicializam objetos. Em Dart, você pode usar construtor padrão, nomeado e factory.",
    );
  }
}

class _ClassTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _ClassTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) =>
      _buildClassPage(title, code, explanation);
}

Widget _buildClassPage(String title, String code, String explanation) {
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
