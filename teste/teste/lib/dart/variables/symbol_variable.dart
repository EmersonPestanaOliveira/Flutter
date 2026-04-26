import 'package:flutter/material.dart';

class SymbolVariablePage extends StatefulWidget {
  const SymbolVariablePage({super.key});

  @override
  State<SymbolVariablePage> createState() => _SymbolVariablePageState();
}

class _SymbolVariablePageState extends State<SymbolVariablePage> {
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

  // =============================
  // CÓDIGOS
  // =============================

  String get declaracaoCode => r'''
// Declaração de Symbol

Symbol simbolo1 = #nome;
// Forma literal usando #

print(simbolo1);
// Exibe o símbolo criado
''';

  String get construtorCode => r'''
// Criando Symbol com construtor

var simbolo2 = Symbol('idade');
// Cria um símbolo a partir de uma string

print(simbolo2);
// Exibe o símbolo
''';

  String get comparacaoCode => r'''
// Comparação entre símbolos

var a = #nome;
var b = #nome;
var c = #idade;

print(a == b);
// true porque representam o mesmo identificador

print(a == c);
// false porque são símbolos diferentes
''';

  String get usoMapCode => r'''
// Usando Symbol como chave de Map

var mapa = {
  #nome: "Ana",
  #idade: 20,
};

print(mapa[#nome]);
// Acessa o valor associado ao símbolo

print(mapa[#idade]);
''';

  String get allCode => r'''
Symbol simbolo1 = #nome;
var simbolo2 = Symbol('idade');

print(simbolo1);
print(simbolo2);

var a = #nome;
var b = #nome;
print(a == b);

var mapa = {
  #nome: "Ana",
  #idade: 20,
};

print(mapa[#nome]);
print(mapa[#idade]);
''';

  // =============================
  // EXECUÇÃO
  // =============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        Symbol simbolo1 = #nome;

        log(simbolo1);
      },
    );
  }

  void runConstrutor() {
    runSection(
      title: "Construtor",
      code: construtorCode,
      action: () {
        var simbolo2 = Symbol('idade');

        log(simbolo2);
      },
    );
  }

  void runComparacao() {
    runSection(
      title: "Comparação",
      code: comparacaoCode,
      action: () {
        var a = #nome;
        var b = #nome;
        var c = #idade;

        log(a == b);
        log(a == c);
      },
    );
  }

  void runUsoMap() {
    runSection(
      title: "Uso em Map",
      code: usoMapCode,
      action: () {
        var mapa = {#nome: "Ana", #idade: 20};

        log(mapa[#nome]);
        log(mapa[#idade]);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    Symbol simbolo1 = #nome;
    var simbolo2 = Symbol('idade');

    log(simbolo1);
    log(simbolo2);

    var a = #nome;
    var b = #nome;

    log(a == b);

    var mapa = {#nome: "Ana", #idade: 20};

    log(mapa[#nome]);
    log(mapa[#idade]);
  }

  // =============================
  // UI
  // =============================

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
          height: 1.5,
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
      appBar: AppBar(title: const Text("Symbol")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo Symbol em Dart",
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
              description: "Criar símbolos usando a sintaxe #nome.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Construtor",
              description: "Criar símbolos usando Symbol('nome').",
              onRun: runConstrutor,
            ),

            buildSection(
              title: "Comparação",
              description: "Comparar símbolos usando operador ==.",
              onRun: runComparacao,
            ),

            buildSection(
              title: "Uso em Map",
              description: "Usar símbolos como chave em mapas.",
              onRun: runUsoMap,
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
