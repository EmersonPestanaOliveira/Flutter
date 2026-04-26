import 'package:flutter/material.dart';
import 'const_example.dart';
import 'final_example.dart';
import 'enums_example.dart';
import 'immutability_example.dart';
import 'constants_table.dart';

class ConstantsPage extends StatelessWidget {
  const ConstantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo das constantes em Dart",
        const ConstantsTablePage(),
      ),
      ("const", "Constante em tempo de compilação", const ConstExamplePage()),
      ("final", "Constante em tempo de execução", const FinalExamplePage()),
      ("Enums", "Valores nomeados fixos", const EnumsExamplePage()),
      (
        "Imutabilidade",
        "const e unmodifiable",
        const ImmutabilityExamplePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Constantes")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            title: Text(item.$1),
            subtitle: Text(item.$2),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$3),
              );
            },
          );
        },
      ),
    );
  }
}
