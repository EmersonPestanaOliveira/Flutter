import 'package:flutter/material.dart';

class FutureExamplePage extends StatelessWidget {
  const FutureExamplePage({super.key});

  String getCode() {
    return r'''
Future<String> carregarDados() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Dados carregados';
}

Future<void> executar() async {
  try {
    print('Iniciando...');
    final resultado = await carregarDados();
    print(resultado);
  } catch (e) {
    print('Erro: $e');
  } finally {
    print('Finalizado');
  }
}

void main() {
  executar();

  carregarDados().then((valor) {
    print('then: $valor');
  }).catchError((e) {
    print('Erro no then: $e');
  });
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _AsyncTemplate(
      title: "Future",
      code: getCode(),
      explanation:
          "Future representa um valor que será produzido no futuro. Ele pode ser consumido com async/await ou com then().",
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
