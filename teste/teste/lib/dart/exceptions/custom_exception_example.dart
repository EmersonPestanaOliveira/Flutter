import 'package:flutter/material.dart';

class CustomExceptionExamplePage extends StatelessWidget {
  const CustomExceptionExamplePage({super.key});

  String getCode() {
    return r'''
class MinhaExcecao implements Exception {
  final String message;

  const MinhaExcecao([this.message = '']);

  @override
  String toString() => 'MinhaExcecao: $message';
}

void validarIdade(int idade) {
  if (idade < 0) {
    throw const MinhaExcecao('Idade não pode ser negativa');
  }
}

void main() {
  try {
    validarIdade(-1);
  } catch (e) {
    print(e);
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ExceptionTemplate(
      title: "Exceções customizadas",
      code: getCode(),
      explanation:
          "Você pode criar sua própria classe de exceção implementando Exception e lançar erros mais específicos no seu domínio.",
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
