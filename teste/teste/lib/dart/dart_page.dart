import 'package:flutter/material.dart';
import 'package:teste/dart/operadores/operators_page.dart';
import 'hello_world/hello_world.dart';
import 'comments/comments.dart';
import 'variables/variables_page.dart';
import 'constants/constants_page.dart';
import 'conditional_structures/conditional_structures_page.dart';
import 'loop_structures/loop_structures_page.dart';
import 'functions/functions_page.dart';
import 'exceptions/exceptions_page.dart';
import 'classes/classes_page.dart';
import 'async/async_page.dart';

class DartPage extends StatelessWidget {
  const DartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dart Examples")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Hello World"),
            subtitle: const Text("Primeiro programa em Dart"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelloWorldPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Comentários"),
            subtitle: const Text("Comentários de uma linha e múltiplas linhas"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommentsPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Variáveis"),
            subtitle: const Text("Tipos de variáveis em Dart"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VariablesPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Constantes"),
            subtitle: const Text("const, final, enums e imutabilidade"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConstantsPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Operadores"),
            subtitle: const Text("Operadores do Dart"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OperatorsPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Estruturas condicionais"),
            subtitle: const Text("if, if else, ternário e switch case"),
            trailing: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConditionalStructuresPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Estruturas de repetição"),
            subtitle: const Text("for, while, do-while e loops em listas"),
            trailing: const Icon(Icons.loop),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoopStructuresPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Funções"),
            subtitle: const Text(
              "Declaração, parâmetros, async, closures e mais",
            ),
            trailing: const Icon(Icons.functions),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FunctionsPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Exceptions"),
            subtitle: const Text(
              "assert, try/catch/finally, rethrow e exceções customizadas",
            ),
            trailing: const Icon(Icons.warning_amber_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExceptionsPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Classe"),
            subtitle: const Text(
              "Classe genérica, orientação a objeto e setter/getter",
            ),
            trailing: const Icon(Icons.class_),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClassesPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Async"),
            subtitle: const Text("Future e Streams"),
            trailing: const Icon(Icons.schedule),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AsyncPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
