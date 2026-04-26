import 'package:flutter/material.dart';
import 'functions_table.dart';
import 'basic_functions.dart';
import 'positional_parameters.dart';
import 'named_parameters.dart';
import 'function_types.dart';
import 'typedef_functions.dart';
import 'generic_functions.dart';
import 'closures_and_scope.dart';
import 'tear_offs.dart';
import 'async_functions.dart';
import 'generators.dart';
import 'record_functions.dart';
import 'special_return_types.dart';
import 'annotations_functions.dart';
import 'function_equality.dart';
import 'shadowing_functions.dart';
import 'higher_order_functions.dart';

class FunctionsPage extends StatelessWidget {
  const FunctionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo do módulo de funções",
        const FunctionsTablePage(),
      ),
      (
        "Básico",
        "Declaração, retorno, void e arrow",
        const BasicFunctionsPage(),
      ),
      (
        "Parâmetros posicionais",
        "Obrigatórios e opcionais",
        const PositionalParametersPage(),
      ),
      (
        "Parâmetros nomeados",
        "required, default e mistura",
        const NamedParametersPage(),
      ),
      (
        "Tipos de função",
        "Funções como tipos e lambdas",
        const FunctionTypesPage(),
      ),
      (
        "typedef",
        "Alias para assinatura de função",
        const TypedefFunctionsPage(),
      ),
      ("Funções genéricas", "Uso de <T> e <R>", const GenericFunctionsPage()),
      (
        "Closures e escopo",
        "Escopo léxico e captura",
        const ClosuresAndScopePage(),
      ),
      ("Tear-offs", "Referências a métodos e funções", const TearOffsPage()),
      (
        "Assíncronas",
        "Future, async, await, then e erro",
        const AsyncFunctionsPage(),
      ),
      (
        "Generators",
        "sync*, async*, Iterable e Stream",
        const GeneratorsPage(),
      ),
      ("Record", "Funções com Records", const RecordFunctionsPage()),
      (
        "Tipos especiais",
        "Never, void, external e covariant",
        const SpecialReturnTypesPage(),
      ),
      (
        "Anotações",
        "@deprecated, @override, @pragma",
        const AnnotationsFunctionsPage(),
      ),
      (
        "Igualdade e identidade",
        "identical e referências",
        const FunctionEqualityPage(),
      ),
      (
        "Shadowing",
        "Sombreamento de variáveis",
        const ShadowingFunctionsPage(),
      ),
      (
        "Alta ordem",
        "Recebem e retornam funções",
        const HigherOrderFunctionsPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Funções")),
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
