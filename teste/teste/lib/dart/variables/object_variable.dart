import 'package:flutter/material.dart';

class ObjectVariablePage extends StatefulWidget {
  const ObjectVariablePage({super.key});

  @override
  State<ObjectVariablePage> createState() => _ObjectVariablePageState();
}

class _ObjectVariablePageState extends State<ObjectVariablePage> {
  final List<String> console = [];
  String currentCode = "// selecione uma seção para executar";

  void log(Object? value) {
    setState(() {
      console.add(value.toString());
    });
  }

  void section(String title, String code) {
    setState(() {
      currentCode = code;
      console.add("");
      console.add("===== $title =====");
    });
  }

  void clearConsole() {
    setState(() {
      console.clear();
    });
  }

  void runSection({
    required String title,
    required String code,
    required VoidCallback action,
  }) {
    section(title, code);
    action();
  }

  // ===============================
  // CÓDIGOS
  // ===============================

  String get declaracaoCode => r'''
// Declaração de Object

Object valor = "Olá";
// Object pode armazenar qualquer objeto

print(valor);
// Exibe o valor atual
''';

  String get trocaTipoCode => r'''
// Mudança de tipo

Object valor = "Olá";

print(valor);
// Valor inicial é uma String

valor = 42;
// Agora o valor é um int

print(valor);
''';

  String get runtimeTypeCode => r'''
// Descobrir tipo real do objeto

Object valor = "Dart";

print(valor.runtimeType);
// Mostra o tipo real armazenado

valor = 3.14;

print(valor.runtimeType);
// Agora o tipo é double
''';

  String get verificacaoTipoCode => r'''
// Verificação de tipo

Object valor = "Flutter";

print(valor is String);
// Verifica se o objeto é String

print(valor is int);
// Verifica se o objeto é int

if (valor is String) {
  print(valor.length);
}
// Após verificação, podemos acessar propriedades
''';

  String get allCode => r'''
Object valor = "Olá";
print(valor);

valor = 42;
print(valor);

print(valor.runtimeType);

Object texto = "Flutter";
print(texto is String);
print(texto is int);
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        Object valor = "Olá";
        log(valor);
      },
    );
  }

  void runTrocaTipo() {
    runSection(
      title: "Mudança de Tipo",
      code: trocaTipoCode,
      action: () {
        Object valor = "Olá";
        log(valor);

        valor = 42;
        log(valor);
      },
    );
  }

  void runRuntimeType() {
    runSection(
      title: "Tipo em Runtime",
      code: runtimeTypeCode,
      action: () {
        Object valor = "Dart";
        log(valor.runtimeType);

        valor = 3.14;
        log(valor.runtimeType);
      },
    );
  }

  void runVerificacaoTipo() {
    runSection(
      title: "Verificação de Tipo",
      code: verificacaoTipoCode,
      action: () {
        Object valor = "Flutter";

        log(valor is String);
        log(valor is int);

        if (valor is String) {
          log(valor.length);
        }
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    Object valor = "Olá";
    log(valor);

    valor = 42;
    log(valor);

    log(valor.runtimeType);

    Object texto = "Flutter";

    log(texto is String);
    log(texto is int);
  }

  // ===============================
  // UI
  // ===============================

  Widget buildSection({
    required String title,
    required String description,
    required VoidCallback onRun,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onRun,
              child: const Text("Executar exemplo"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeViewer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SelectableText(
        currentCode,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "monospace",
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildConsole() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: console.isEmpty
          ? const Text(
              "Console vazio",
              style: TextStyle(color: Colors.white54, fontFamily: "monospace"),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: console
                  .map(
                    (e) => Text(
                      e,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: "monospace",
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Object")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo Object em Dart",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: runAll,
                  child: const Text("Executar tudo"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: clearConsole,
                  child: const Text("Limpar console"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            buildSection(
              title: "Declaração",
              description: "Object pode armazenar qualquer objeto.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Mudança de Tipo",
              description:
                  "O valor armazenado pode ser substituído por outro objeto.",
              onRun: runTrocaTipo,
            ),

            buildSection(
              title: "Tipo em Runtime",
              description:
                  "Descobrir o tipo real do objeto em tempo de execução.",
              onRun: runRuntimeType,
            ),

            buildSection(
              title: "Verificação de Tipo",
              description:
                  "Usar 'is' para verificar o tipo antes de acessar propriedades.",
              onRun: runVerificacaoTipo,
            ),

            const SizedBox(height: 24),

            const Text(
              "Código executado:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildCodeViewer(),

            const SizedBox(height: 24),

            const Text(
              "Console:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildConsole(),
          ],
        ),
      ),
    );
  }
}
