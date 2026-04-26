import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  String getCode() {
    return '''
void main() {
  // Este é um comentário de uma linha

  /*
    Este é um comentário
    de múltiplas linhas
  */

  print("Olá, Dart!");
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comentários")),
      body: Padding(
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
              child: Text(
                getCode(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "monospace",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Explicação:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "// usa comentário de uma linha.\n\n"
              "/* */ usa comentário de múltiplas linhas.\n\n"
              "Comentários servem para explicar o código e não são executados.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
