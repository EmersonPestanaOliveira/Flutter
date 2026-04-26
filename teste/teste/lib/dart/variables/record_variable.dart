import 'package:flutter/material.dart';

class RecordVariablePage extends StatefulWidget {
  const RecordVariablePage({super.key});

  @override
  State<RecordVariablePage> createState() => _RecordVariablePageState();
}

class _RecordVariablePageState extends State<RecordVariablePage> {
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

  String get criacaoCode => r'''
// Criação de records posicionais

var pessoa = ('Ana', 20, true);
// Record com 3 campos posicionais

print(pessoa);
// Exibe o record completo

print(pessoa.$1);
// Acessa o primeiro campo

print(pessoa.$2);
// Acessa o segundo campo

print(pessoa.$3);
// Acessa o terceiro campo
''';

  String get nomeadosCode => r'''
// Records com campos nomeados

var produto = (nome: 'Notebook', preco: 3500.0, ativo: true);
// Record com campos nomeados

print(produto);
// Exibe o record completo

print(produto.nome);
// Acessa o campo nome

print(produto.preco);
// Acessa o campo preco

print(produto.ativo);
// Acessa o campo ativo
''';

  String get tipagemCode => r'''
// Record com tipo explícito

(String, int) usuario = ('Carlos', 30);
// Record tipado com String e int

print(usuario.$1);
// Acessa o primeiro campo

print(usuario.$2);
// Acessa o segundo campo
''';

  String get combinadosCode => r'''
// Record com campos posicionais e nomeados

var pedido = (101, nome: 'Mouse', preco: 99.9);
// Primeiro campo é posicional, os outros são nomeados

print(pedido);
// Exibe o record completo

print(pedido.$1);
// Campo posicional

print(pedido.nome);
// Campo nomeado

print(pedido.preco);
// Campo nomeado
''';

  String get comparacaoCode => r'''
// Comparação entre records

var a = ('Ana', 20);
var b = ('Ana', 20);
var c = ('Carlos', 30);

print(a == b);
// true porque os valores e a estrutura são iguais

print(a == c);
// false porque os valores são diferentes
''';

  String get allCode => r'''
var pessoa = ('Ana', 20, true);
print(pessoa);
print(pessoa.$1);
print(pessoa.$2);
print(pessoa.$3);

var produto = (nome: 'Notebook', preco: 3500.0, ativo: true);
print(produto.nome);
print(produto.preco);
print(produto.ativo);

(String, int) usuario = ('Carlos', 30);
print(usuario.$1);
print(usuario.$2);

var pedido = (101, nome: 'Mouse', preco: 99.9);
print(pedido.$1);
print(pedido.nome);
print(pedido.preco);
''';

  void runCriacao() {
    runSection(
      title: "Campos Posicionais",
      code: criacaoCode,
      action: () {
        var pessoa = ('Ana', 20, true);

        log(pessoa);
        log(pessoa.$1);
        log(pessoa.$2);
        log(pessoa.$3);
      },
    );
  }

  void runNomeados() {
    runSection(
      title: "Campos Nomeados",
      code: nomeadosCode,
      action: () {
        var produto = (nome: 'Notebook', preco: 3500.0, ativo: true);

        log(produto);
        log(produto.nome);
        log(produto.preco);
        log(produto.ativo);
      },
    );
  }

  void runTipagem() {
    runSection(
      title: "Tipagem Explícita",
      code: tipagemCode,
      action: () {
        (String, int) usuario = ('Carlos', 30);

        log(usuario.$1);
        log(usuario.$2);
      },
    );
  }

  void runCombinados() {
    runSection(
      title: "Campos Mistos",
      code: combinadosCode,
      action: () {
        var pedido = (101, nome: 'Mouse', preco: 99.9);

        log(pedido);
        log(pedido.$1);
        log(pedido.nome);
        log(pedido.preco);
      },
    );
  }

  void runComparacao() {
    runSection(
      title: "Comparação",
      code: comparacaoCode,
      action: () {
        var a = ('Ana', 20);
        var b = ('Ana', 20);
        var c = ('Carlos', 30);

        log(a == b);
        log(a == c);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    var pessoa = ('Ana', 20, true);
    log(pessoa);
    log(pessoa.$1);
    log(pessoa.$2);
    log(pessoa.$3);

    var produto = (nome: 'Notebook', preco: 3500.0, ativo: true);
    log(produto.nome);
    log(produto.preco);
    log(produto.ativo);

    (String, int) usuario = ('Carlos', 30);
    log(usuario.$1);
    log(usuario.$2);

    var pedido = (101, nome: 'Mouse', preco: 99.9);
    log(pedido.$1);
    log(pedido.nome);
    log(pedido.preco);
  }

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
      constraints: const BoxConstraints(minHeight: 220),
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
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: "monospace",
                          fontSize: 14,
                        ),
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
      appBar: AppBar(title: const Text("Record")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo Record em Dart",
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
              title: "Campos Posicionais",
              description: "Criar records e acessar com \$1, \$2 e \$3.",
              onRun: runCriacao,
            ),
            buildSection(
              title: "Campos Nomeados",
              description: "Criar records com propriedades nomeadas.",
              onRun: runNomeados,
            ),
            buildSection(
              title: "Tipagem Explícita",
              description: "Definir o tipo do record manualmente.",
              onRun: runTipagem,
            ),
            buildSection(
              title: "Campos Mistos",
              description: "Misturar campo posicional com campos nomeados.",
              onRun: runCombinados,
            ),
            buildSection(
              title: "Comparação",
              description: "Comparar records pelo conteúdo e estrutura.",
              onRun: runComparacao,
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
