import 'package:flutter/material.dart';

class CollectionOperatorsPage extends StatelessWidget {
  const CollectionOperatorsPage({super.key});

  String getCode() {
    return r'''
void main() {
  var lista = [1, 2];
  var novaLista = [0, ...lista, 3];
  print(novaLista);

  List<int>? opcional;
  var lista2 = [0, ...?opcional, 4];
  print(lista2);

  bool ativo = true;
  var menu = [
    'Home',
    if (ativo) 'Perfil',
    'Sair',
  ];
  print(menu);

  var numeros = [1, 2, 3];
  var dobrados = [
    for (var n in numeros) n * 2,
  ];
  print(dobrados);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return _Template(
      title: "Operadores de Coleção",
      code: getCode(),
      explanation:
          "Esses recursos ajudam a montar listas, sets e mapas de forma dinâmica e expressiva.",
    );
  }
}

class _Template extends StatelessWidget {
  final String title;
  final String code;
  final String explanation;

  const _Template({
    required this.title,
    required this.code,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) => _buildPage(title, code, explanation);
}

Widget _buildPage(String title, String code, String explanation) {
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
