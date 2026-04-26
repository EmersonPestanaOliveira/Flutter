import 'package:flutter/material.dart';

class GenericFunctionsPage extends StatelessWidget {
  const GenericFunctionsPage({super.key});

  String getCode() {
    return r'''
T escolher<T>(T a, T b, bool cond) => cond ? a : b;

List<R> mapear<T, R>(Iterable<T> xs, R Function(T) f) {
  final out = <R>[];
  for (final x in xs) {
    out.add(f(x));
  }
  return out;
}

void main() {
  print(escolher<int>(10, 20, true));
  print(escolher<String>('A', 'B', false));

  print(mapear<int, String>([1, 2, 3], (n) => 'item $n'));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Funções genéricas",
      code: getCode(),
      explanation:
          "Funções genéricas permitem reutilizar lógica para diferentes tipos usando parâmetros como <T> e <R>.",
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
