import 'package:flutter/material.dart';

class TypedefFunctionsPage extends StatelessWidget {
  const TypedefFunctionsPage({super.key});

  String getCode() {
    return r'''
typedef BinOp = int Function(int, int);

int calcular(int a, int b, BinOp op) => op(a, b);

int somar(int x, int y) => x + y;
int multiplicar(int x, int y) => x * y;

void main() {
  print(calcular(2, 3, somar));
  print(calcular(4, 5, multiplicar));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "typedef",
      code: getCode(),
      explanation:
          "typedef cria um apelido para uma assinatura de função, deixando o código mais legível.",
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
