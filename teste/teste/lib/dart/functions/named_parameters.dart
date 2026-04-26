import 'package:flutter/material.dart';

class NamedParametersPage extends StatelessWidget {
  const NamedParametersPage({super.key});

  String getCode() {
    return r'''
String titulo({String prefixo = 'Sr.', required String nome}) => '$prefixo $nome';

String welcome(String app, {String usuario = 'Guest'}) => '$app - $usuario';

void main() {
  print(titulo(nome: 'Carlos'));
  print(titulo(prefixo: 'Dr.', nome: 'João'));

  print(welcome('MeuApp'));
  print(welcome('MeuApp', usuario: 'Ana'));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Parâmetros nomeados",
      code: getCode(),
      explanation:
          "Parâmetros nomeados usam chaves {}, podem ser required e também ter valores padrão.",
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
