import 'package:flutter/material.dart';

class RecordFunctionsPage extends StatelessWidget {
  const RecordFunctionsPage({super.key});

  String getCode() {
    return r'''
int area((int, int) dims) {
  var (w, h) = dims;
  return w * h;
}

String formatUser(({String nome, int idade}) u) => '${u.nome} (${u.idade})';

void main() {
  print(area((10, 20)));
  print(formatUser((nome: 'Ana', idade: 30)));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Record",
      code: getCode(),
      explanation:
          "Funções podem receber Records posicionais ou nomeados, inclusive com pattern matching.",
    );
  }
}

class _FunctionTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _FunctionTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) =>
      _buildFunctionPage(title, code, explanation);
}

Widget _buildFunctionPage(String title, String code, String explanation) {
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
