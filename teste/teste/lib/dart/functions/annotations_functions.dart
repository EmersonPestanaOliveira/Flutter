import 'package:flutter/material.dart';

class AnnotationsFunctionsPage extends StatelessWidget {
  const AnnotationsFunctionsPage({super.key});

  String getCode() {
    return r'''
class Base {
  void falar() {
    print('Base');
  }
}

class Filho extends Base {
  @override
  void falar() {
    print('Filho');
  }
}

@deprecated
void antigaFuncao() {
  print('Função antiga');
}

@pragma('vm:prefer-inline')
int dobrar(int x) => x * 2;

void main() {
  final f = Filho();
  f.falar();

  antigaFuncao();
  print(dobrar(5));
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionTemplate(
      title: "Anotações",
      code: getCode(),
      explanation:
          "Anotações como @deprecated, @override e @pragma adicionam metadados e comportamento especial ao código.",
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
