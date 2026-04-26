import 'package:flutter/material.dart';

class StreamTransformExamplePage extends StatelessWidget {
  const StreamTransformExamplePage({super.key});

  String getCode() {
    return r'''
Stream<int> numeros() async* {
  for (var i = 1; i <= 5; i++) {
    yield i;
  }
}

Future<void> main() async {
  final stream = numeros()
      .where((n) => n.isEven)
      .map((n) => n * 10);

  await for (final valor in stream) {
    print(valor);
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _AsyncTemplate(
      title: "Transformação de Streams",
      code: getCode(),
      explanation:
          "Streams podem ser filtradas e transformadas com operações como where() e map(), de forma parecida com Iterable.",
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
