import 'package:flutter/material.dart';

class StaticMembersPage extends StatelessWidget {
  const StaticMembersPage({super.key});

  String getCode() {
    return r'''
class Matematica {
  static const double pi = 3.14159;

  static int somar(int a, int b) {
    return a + b;
  }
}

void main() {
  print(Matematica.pi);
  print(Matematica.somar(2, 3));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _ClassTemplate(
      title: "Static",
      code: getCode(),
      explanation:
          "Membros static pertencem à classe, não ao objeto. Você pode acessá-los sem criar instância.",
    );
  }
}

class _ClassTemplate extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _ClassTemplate({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) =>
      _buildClassPage(title, code, explanation);
}

Widget _buildClassPage(String title, String code, String explanation) {
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
