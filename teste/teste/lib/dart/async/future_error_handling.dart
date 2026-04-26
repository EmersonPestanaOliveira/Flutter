import 'package:flutter/material.dart';

class FutureErrorHandlingPage extends StatelessWidget {
  const FutureErrorHandlingPage({super.key});

  String getCode() {
    return r'''
Future<String> buscarDados() async {
  await Future.delayed(Duration(seconds: 1));
  throw Exception('Falha ao buscar dados');
}

Future<void> exemploAsyncAwait() async {
  try {
    final resultado = await buscarDados();
    print(resultado);
  } catch (e) {
    print('Erro com await: $e');
  }
}

void exemploThen() {
  buscarDados().then((valor) {
    print(valor);
  }).catchError((e) {
    print('Erro com then: $e');
  });
}

Future<void> exemploTimeout() async {
  try {
    final resultado = await buscarDados().timeout(
      Duration(milliseconds: 500),
    );
    print(resultado);
  } catch (e) {
    print('Erro de timeout ou falha: $e');
  }
}

void main() async {
  await exemploAsyncAwait();
  exemploThen();
  await exemploTimeout();
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _AsyncTemplate(
      title: "Tratamento de erro em Future",
      code: getCode(),
      explanation:
          "Erros em Future podem ser tratados com try/catch ao usar await, ou com catchError ao usar then. Também é possível definir timeout.",
    );
  }
}

class _AsyncTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _AsyncTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) =>
      _buildAsyncPage(title, code, explanation);
}

Widget _buildAsyncPage(String title, String code, String explanation) {
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
