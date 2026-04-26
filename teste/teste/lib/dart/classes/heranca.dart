import 'package:flutter/material.dart';

class HerancaPage extends StatelessWidget {
  const HerancaPage({super.key});

  String getCode() {
    return r'''
class Animal {
  String nome;

  Animal(this.nome);

  void fazerSom() {
    print('Som genérico');
  }
}

class Cachorro extends Animal {
  Cachorro(super.nome);

  @override
  void fazerSom() {
    print('$nome faz: Au Au');
  }
}

void main() {
  var dog = Cachorro('Rex');
  dog.fazerSom();
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ClassTemplate(
      title: "Herança",
      code: getCode(),
      explanation:
          "Herança permite que uma classe filha reutilize e especialize comportamentos de uma classe pai usando extends.",
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
