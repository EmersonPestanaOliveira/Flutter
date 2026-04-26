import 'package:flutter/material.dart';

class StreamsExamplePage extends StatelessWidget {
  const StreamsExamplePage({super.key});

  String getCode() {
    return r'''
Stream<int> contarAte(int n) async* {
  for (var i = 1; i <= n; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;
  }
}

Future<void> consumirStream() async {
  await for (final numero in contarAte(5)) {
    print('Número: $numero');
  }
}

void main() {
  consumirStream();

  contarAte(3).listen(
    (valor) {
      print('listen: $valor');
    },
    onDone: () {
      print('Stream finalizada');
    },
    onError: (e) {
      print('Erro: $e');
    },
  );
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _AsyncTemplate(
      title: "Streams",
      code: getCode(),
      explanation:
          "Stream representa uma sequência assíncrona de múltiplos valores. Você pode consumir com await for ou com listen().",
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
