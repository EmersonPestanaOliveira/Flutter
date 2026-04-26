import 'package:flutter/material.dart';

class SetterGetterPage extends StatelessWidget {
  const SetterGetterPage({super.key});

  String getCode() {
    return r'''
class Pessoa {
  String _nome = '';
  int _idade = 0;

  String get nome => _nome;
  int get idade => _idade;

  set nome(String valor) {
    _nome = valor;
  }

  set idade(int valor) {
    if (valor >= 0) {
      _idade = valor;
    }
  }

  String get resumo => '$_nome tem $_idade anos';
}

void main() {
  var pessoa = Pessoa();

  pessoa.nome = 'Carlos';
  pessoa.idade = 30;

  print(pessoa.nome);
  print(pessoa.idade);
  print(pessoa.resumo);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ClassTemplate(
      title: "Setter e Getter",
      code: getCode(),
      explanation:
          "Getters leem valores e setters definem valores. Eles ajudam no encapsulamento e permitem validações antes de alterar o estado.",
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
