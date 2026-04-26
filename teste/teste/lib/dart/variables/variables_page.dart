import 'package:flutter/material.dart';
import 'string_variable.dart';
import 'int_variable.dart';
import 'double_variable.dart';
import 'num_variable.dart';
import 'bool_variable.dart';
import 'dynamic_variable.dart';
import 'var_variable.dart';
import 'object_variable.dart';
import 'list_variable.dart';
import 'map_variable.dart';
import 'set_variable.dart';
import 'nullable_variable.dart';
import 'variables_table.dart';
import 'type_conversion.dart';
import 'null_variable.dart';
import 'record_variable.dart';
import 'symbol_variable.dart';
import 'type_t_variable.dart';
import 'null_safety_variable.dart';
import 'late_variable.dart';
import 'generic_types_variable.dart';

class VariablesPage extends StatelessWidget {
  const VariablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo de todos os tipos de variáveis",
        const VariablesTablePage(),
      ),
      ("String", "Texto", const StringVariablePage()),
      ("int", "Números inteiros", const IntVariablePage()),
      ("double", "Números decimais", const DoubleVariablePage()),
      ("num", "Inteiro ou decimal", const NumVariablePage()),
      ("bool", "Verdadeiro ou falso", const BoolVariablePage()),
      ("dynamic", "Tipo dinâmico", const DynamicVariablePage()),
      ("var", "Inferência de tipo", const VarVariablePage()),
      ("Object", "Tipo base de objetos", const ObjectVariablePage()),
      ("List", "Lista de valores", const ListVariablePage()),
      ("Map", "Chave e valor", const MapVariablePage()),
      ("Set", "Valores únicos", const SetVariablePage()),
      ("Nullable", "Tipos com null", const NullableVariablePage()),
      (
        "Conversões",
        "Conversões entre tipos em Dart",
        const TypeConversionPage(),
      ),
      ("Null", "Valor nulo em Dart", const NullVariablePage()),
      (
        "Record",
        "Agrupamento de múltiplos valores",
        const RecordVariablePage(),
      ),
      (
        "Symbol",
        "Representação simbólica de identificadores",
        const SymbolVariablePage(),
      ),
      ("T", "Tipo genérico representado por T", const TypeTVariablePage()),
      (
        "Null Safety",
        "Segurança contra valores nulos",
        const NullSafetyVariablePage(),
      ),
      ("late", "Inicialização tardia", const LateVariablePage()),
      (
        "Tipos Genéricos",
        "Tipos parametrizados",
        const GenericTypesVariablePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Variáveis")),
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
