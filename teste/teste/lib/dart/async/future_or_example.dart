import 'package:flutter/material.dart';

class FutureOrExamplePage extends StatelessWidget {
  const FutureOrExamplePage({super.key});

  String getCode() {
    return r'''
import 'dart:async';

FutureOr<String> saudacao(bool rapido) {
  if (rapido) {
    return 'Olá imediato';
  }

  return Future.delayed(
    Duration(seconds: 1),
    () => 'Olá assíncrono',
  );
}

Future<void> main() async {
  print(await saudacao(true));
  print(await saudacao(false));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _AsyncTemplate(
      title: "FutureOr",
      code: getCode(),
      explanation:
          "FutureOr<T> permite retornar tanto um valor síncrono quanto um Future<T>. É útil quando uma operação pode ser imediata ou assíncrona.",
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
