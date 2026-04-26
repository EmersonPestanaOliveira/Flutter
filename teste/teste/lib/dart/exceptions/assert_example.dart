import 'package:flutter/material.dart';

class AssertExamplePage extends StatelessWidget {
  const AssertExamplePage({super.key});

  String getCode() {
    return r'''
int dividir(int a, int b) {
  assert(b != 0, 'b não pode ser zero');
  return a ~/ b;
}

int raizInt(int n) {
  assert(n >= 0, 'n deve ser >= 0');
  return 0;
}

class Intervalo {
  final int inicio;
  final int fim;

  Intervalo(this.inicio, this.fim)
      : assert(inicio <= fim, 'inicio deve ser <= fim');
}

int somaPositivos(List<int> xs) {
  final total = xs.fold(0, (a, b) => a + b);
  assert(total >= 0);
  return total;
}

void main() {
  print(dividir(10, 2));
  print(Intervalo(1, 5).inicio);
  print(somaPositivos([1, 2, 3]));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ExceptionTemplate(
      title: "assert",
      code: getCode(),
      explanation:
          "assert verifica condições em tempo de execução apenas no modo debug. É útil para pré-condições, invariantes e sanity checks.",
    );
  }
}

class _ExceptionTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _ExceptionTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) =>
      _buildExceptionPage(title, code, explanation);
}

Widget _buildExceptionPage(String title, String code, String explanation) {
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
