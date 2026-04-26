import 'package:flutter/material.dart';
import 'conditional_structures_table.dart';
import 'if_example.dart';
import 'if_else_example.dart';
import 'if_else_if_else_example.dart';
import 'ternary_operator_example.dart';
import 'switch_case_example.dart';

class ConditionalStructuresPage extends StatelessWidget {
  const ConditionalStructuresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo das estruturas condicionais",
        const ConditionalStructuresTablePage(),
      ),
      (
        "IF",
        "Executa um bloco se a condição for verdadeira",
        const IfExamplePage(),
      ),
      ("IF ELSE", "Escolhe entre dois blocos", const IfElseExamplePage()),
      (
        "IF - ELSE IF - ELSE",
        "Múltiplas condições",
        const IfElseIfElseExamplePage(),
      ),
      (
        "Operador Ternário",
        "Condição em uma única expressão",
        const TernaryOperatorExamplePage(),
      ),
      (
        "SWITCH CASE",
        "Seleciona um caso entre vários",
        const SwitchCaseExamplePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Estruturas condicionais")),
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
