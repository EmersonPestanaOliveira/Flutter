import 'package:flutter/material.dart';
import 'loop_structures_table.dart';
import 'for_example.dart';
import 'while_example.dart';
import 'do_while_example.dart';
import 'for_each_example.dart';
import 'for_in_example.dart';

class LoopStructuresPage extends StatelessWidget {
  const LoopStructuresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo das estruturas de repetição",
        const LoopStructuresTablePage(),
      ),
      ("FOR", "Loop tradicional com contador", const ForExamplePage()),
      (
        "WHILE",
        "Executa enquanto a condição for verdadeira",
        const WhileExamplePage(),
      ),
      ("DO WHILE", "Executa pelo menos uma vez", const DoWhileExamplePage()),
      (
        "forEach em uma lista",
        "Percorre listas usando função",
        const ForEachExamplePage(),
      ),
      (
        "for-in em uma lista",
        "Percorre elementos diretamente",
        const ForInExamplePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Estruturas de repetição")),
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
