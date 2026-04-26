import 'package:flutter/material.dart';

class HigherOrderFunctionsPage extends StatelessWidget {
  const HigherOrderFunctionsPage({super.key});

  String getCode() {
    return r'''
void executarOperacao(int a, int b, int Function(int, int) operacao) {
  final resultado = operacao(a, b);
  print('Resultado: $resultado');
}

Function multiplicador(int fator) {
  return (int valor) => valor * fator;
}

void main() {
  executarOperacao(2, 3, (x, y) => x + y);
  executarOperacao(5, 2, (x, y) => x * y);

  var dobra = multiplicador(2);
  var triplica = multiplicador(3);

  print(dobra(5));
  print(triplica(5));

  var lista = [1, 2, 3, 4];
  var dobrados = lista.map((n) => n * 2).toList();
  var pares = lista.where((n) => n.isEven).toList();
  var soma = lista.reduce((a, b) => a + b);

  print(dobrados);
  print(pares);
  print(soma);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Alta ordem",
      code: getCode(),
      explanation:
          "Funções de alta ordem recebem funções como parâmetro ou retornam funções como resultado.",
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
