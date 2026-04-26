import 'package:flutter/material.dart';

class ClosuresAndScopePage extends StatelessWidget {
  const ClosuresAndScopePage({super.key});

  String getCode() {
    return r'''
Function contador() {
  var n = 0;
  return () {
    n++;
    return n;
  };
}

Function saudacaoPersonalizada(String nome) {
  final prefixo = 'Olá';
  return () => '$prefixo, $nome!';
}

int Function() makeCounter2(int start, int step) {
  var n = start;
  return () => n += step;
}

void main() {
  final inc = contador();
  print(inc());
  print(inc());

  final olaAna = saudacaoPersonalizada('Ana');
  print(olaAna());

  final contador2 = makeCounter2(10, 5);
  print(contador2());
  print(contador2());
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Closures e escopo",
      code: getCode(),
      explanation:
          "Closures capturam variáveis do escopo léxico e mantêm esses valores vivos mesmo após a função externa terminar.",
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
