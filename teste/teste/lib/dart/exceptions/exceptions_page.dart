import 'package:flutter/material.dart';
import 'exceptions_table.dart';
import 'assert_example.dart';
import 'try_catch_finally_example.dart';
import 'exception_details_example.dart';
import 'exception_filtering_example.dart';
import 'rethrow_example.dart';
import 'custom_exception_example.dart';

class ExceptionsPage extends StatelessWidget {
  const ExceptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo do módulo de exceptions",
        const ExceptionsTablePage(),
      ),
      ("assert", "Checagens em modo debug", const AssertExamplePage()),
      (
        "try / catch / finally",
        "Tratamento básico de exceções",
        const TryCatchFinallyExamplePage(),
      ),
      (
        "Detalhes do erro",
        "Capturando e e stackTrace",
        const ExceptionDetailsExamplePage(),
      ),
      (
        "Filtrando exceções",
        "Uso de on com tipos específicos",
        const ExceptionFilteringExamplePage(),
      ),
      ("rethrow", "Relançando exceções", const RethrowExamplePage()),
      (
        "Exceções customizadas",
        "Criando sua própria exception",
        const CustomExceptionExamplePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Exceptions")),
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
