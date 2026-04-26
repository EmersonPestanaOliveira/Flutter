import 'package:flutter/material.dart';

class VarVariablePage extends StatefulWidget {
  const VarVariablePage({super.key});

  @override
  State<VarVariablePage> createState() => _VarVariablePageState();
}

class _VarVariablePageState extends State<VarVariablePage> {
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
// Declaração usando var

var nome = "Carlos";
// O Dart detecta automaticamente que o tipo é String

print(nome);
// Exibe o valor da variável
''';

  String get inferenciaCode => r'''
// Inferência de tipo

var idade = 30;
// Dart infere que o tipo é int

print(idade);

print(idade.runtimeType);
// Mostra o tipo detectado pelo Dart
''';

  String get imutabilidadeTipoCode => r'''
// O tipo não pode mudar

var nome = "Carlos";
// Tipo inferido: String

print(nome);

// nome = 10;
// Isso causaria erro de compilação
// porque o tipo foi definido como String
''';

  String get exemplosCode => r'''
// var pode inferir vários tipos

var texto = "Dart";
var numero = 10;
var decimal = 3.14;
var ativo = true;

print(texto);
print(numero);
print(decimal);
print(ativo);

print(texto.runtimeType);
print(numero.runtimeType);
print(decimal.runtimeType);
print(ativo.runtimeType);
''';

  String get allCode => r'''
var nome = "Carlos";
print(nome);

var idade = 30;
print(idade);
print(idade.runtimeType);

var texto = "Dart";
var numero = 10;
var decimal = 3.14;
var ativo = true;

print(texto);
print(numero);
print(decimal);
print(ativo);
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        var nome = "Carlos";
        log(nome);
      },
    );
  }

  void runInferencia() {
    runSection(
      title: "Inferência de Tipo",
      code: inferenciaCode,
      action: () {
        var idade = 30;

        log(idade);
        log(idade.runtimeType);
      },
    );
  }

  void runImutabilidadeTipo() {
    runSection(
      title: "Tipo Fixo",
      code: imutabilidadeTipoCode,
      action: () {
        var nome = "Carlos";

        log(nome);
        log("Tipo inferido: ${nome.runtimeType}");
        log("Trocar o tipo causaria erro de compilação");
      },
    );
  }

  void runExemplos() {
    runSection(
      title: "Exemplos",
      code: exemplosCode,
      action: () {
        var texto = "Dart";
        var numero = 10;
        var decimal = 3.14;
        var ativo = true;

        log(texto);
        log(numero);
        log(decimal);
        log(ativo);

        log(texto.runtimeType);
        log(numero.runtimeType);
        log(decimal.runtimeType);
        log(ativo.runtimeType);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    var nome = "Carlos";
    log(nome);

    var idade = 30;
    log(idade);
    log(idade.runtimeType);

    var texto = "Dart";
    var numero = 10;
    var decimal = 3.14;
    var ativo = true;

    log(texto);
    log(numero);
    log(decimal);
    log(ativo);
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
      appBar: AppBar(title: const Text("var")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "var em Dart",
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
              description: "Criação de variável usando var.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Inferência de Tipo",
              description: "O Dart detecta automaticamente o tipo.",
              onRun: runInferencia,
            ),

            buildSection(
              title: "Tipo Fixo",
              description: "Após definido, o tipo não pode mudar.",
              onRun: runImutabilidadeTipo,
            ),

            buildSection(
              title: "Exemplos",
              description: "var funcionando com vários tipos.",
              onRun: runExemplos,
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
