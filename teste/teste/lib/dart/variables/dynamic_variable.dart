import 'package:flutter/material.dart';

class DynamicVariablePage extends StatefulWidget {
  const DynamicVariablePage({super.key});

  @override
  State<DynamicVariablePage> createState() => _DynamicVariablePageState();
}

class _DynamicVariablePageState extends State<DynamicVariablePage> {
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
// Declaração de variável dynamic

dynamic valor = "Texto";
// dynamic permite armazenar qualquer tipo

print(valor);
// Exibe o valor atual
''';

  String get trocaTipoCode => r'''
// Mudança de tipo em runtime

dynamic valor = "Texto";

print(valor);
// Valor inicial é uma String

valor = 10;
// Agora vira um int

print(valor);

valor = true;
// Agora vira um bool

print(valor);
''';

  String get operacoesCode => r'''
// Operações com dynamic

dynamic valor = "Dart";

print(valor.length);
// dynamic permite acessar propriedades em runtime

valor = 5;

print(valor + 10);
// Agora valor é tratado como número
''';

  String get verificacaoCode => r'''
// Verificação de tipo

dynamic valor = 10;

print(valor is int);
// Verifica se o tipo é int

print(valor is String);
// Verifica se é String

print(valor.runtimeType);
// Mostra o tipo real da variável
''';

  String get allCode => r'''
dynamic valor = "Texto";
print(valor);

valor = 10;
print(valor);

valor = true;
print(valor);

print(valor.runtimeType);
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        dynamic valor = "Texto";
        log(valor);
      },
    );
  }

  void runTrocaTipo() {
    runSection(
      title: "Mudança de Tipo",
      code: trocaTipoCode,
      action: () {
        dynamic valor = "Texto";
        log(valor);

        valor = 10;
        log(valor);

        valor = true;
        log(valor);
      },
    );
  }

  void runOperacoes() {
    runSection(
      title: "Operações",
      code: operacoesCode,
      action: () {
        dynamic valor = "Dart";
        log(valor.length);

        valor = 5;
        log(valor + 10);
      },
    );
  }

  void runVerificacao() {
    runSection(
      title: "Verificação de Tipo",
      code: verificacaoCode,
      action: () {
        dynamic valor = 10;

        log(valor is int);
        log(valor is String);
        log(valor.runtimeType);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    dynamic valor = "Texto";
    log(valor);

    valor = 10;
    log(valor);

    valor = true;
    log(valor);

    log(valor.runtimeType);
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
      appBar: AppBar(title: const Text("dynamic")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo dynamic em Dart",
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
              description: "Variáveis dynamic podem receber qualquer tipo.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Mudança de Tipo",
              description: "O tipo pode mudar durante a execução.",
              onRun: runTrocaTipo,
            ),

            buildSection(
              title: "Operações",
              description: "dynamic permite acessar propriedades em runtime.",
              onRun: runOperacoes,
            ),

            buildSection(
              title: "Verificação de Tipo",
              description: "Descobrir o tipo real da variável.",
              onRun: runVerificacao,
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
