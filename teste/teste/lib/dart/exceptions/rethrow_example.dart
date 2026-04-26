import 'package:flutter/material.dart';

class RethrowExamplePage extends StatelessWidget {
  const RethrowExamplePage({super.key});

  String getCode() {
    return r'''
void processar() {
  try {
    int.parse('abc');
  } catch (e) {
    print('Erro detectado, propagando...');
    rethrow;
  }
}

void main() {
  try {
    processar();
  } catch (e) {
    print('Erro no main: $e');
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ExceptionTemplate(
      title: "rethrow",
      code: getCode(),
      explanation:
          "rethrow relança a exceção atual preservando o stack trace original.",
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
