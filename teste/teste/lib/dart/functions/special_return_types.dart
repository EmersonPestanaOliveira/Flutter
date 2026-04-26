import 'package:flutter/material.dart';

class SpecialReturnTypesPage extends StatelessWidget {
  const SpecialReturnTypesPage({super.key});

  String getCode() {
    return r'''
Never falhar(String msg) => throw StateError(msg);

void logar(String msg) {
  print(msg);
}

external String obterValorExterno();

class Animal {
  void falar(Object som) {}
}

class Cachorro extends Animal {
  @override
  void falar(covariant String som) {
    print(som);
  }
}

void main() {
  logar('Olá');
  // falhar('Erro fatal');
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Tipos especiais",
      code: getCode(),
      explanation:
          "Esse grupo inclui Never, void, external e covariant. São recursos mais avançados de assinatura e sobrescrita.",
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
