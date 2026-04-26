import 'package:flutter/material.dart';
import 'operators_table.dart';
import 'arithmetic_operators.dart';
import 'unary_operators.dart';
import 'increment_decrement_operators.dart';
import 'compound_assignment_operators.dart';
import 'relational_operators.dart';
import 'logical_operators.dart';
import 'conditional_assignment_operators.dart';
import 'null_aware_operators.dart';
import 'type_operators.dart';
import 'cascade_operators.dart';
import 'collection_operators.dart';

class OperatorsPage extends StatelessWidget {
  const OperatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo de todos os operadores",
        const OperatorsTablePage(),
      ),
      (
        "Aritméticos",
        "Operações matemáticas básicas",
        const ArithmeticOperatorsPage(),
      ),
      (
        "Unários",
        "Operadores aplicados a um operando",
        const UnaryOperatorsPage(),
      ),
      (
        "Incremento e Decremento",
        "++ e --",
        const IncrementDecrementOperatorsPage(),
      ),
      (
        "Atribuição Combinada",
        "Operadores como +=, -=, *=",
        const CompoundAssignmentOperatorsPage(),
      ),
      (
        "Relacionais",
        "Comparações e condicionais",
        const RelationalOperatorsPage(),
      ),
      ("Lógicos", "&&, || e !", const LogicalOperatorsPage()),
      (
        "Atribuição Condicional",
        "?:, ??, ??=",
        const ConditionalAssignmentOperatorsPage(),
      ),
      (
        "Null-aware",
        "Operadores para valores nulos",
        const NullAwareOperatorsPage(),
      ),
      ("Operadores de Tipo", "is, is! e as", const TypeOperatorsPage()),
      ("Operadores Cascata", ".. e ?..", const CascadeOperatorsPage()),
      (
        "Operadores de Coleção",
        "... , ...? , if e for",
        const CollectionOperatorsPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Operadores")),
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
