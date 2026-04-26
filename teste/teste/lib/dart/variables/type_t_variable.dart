import 'package:flutter/material.dart';

class TypeTVariablePage extends StatefulWidget {
  const TypeTVariablePage({super.key});

  @override
  State<TypeTVariablePage> createState() => _TypeTVariablePageState();
}

class _TypeTVariablePageState extends State<TypeTVariablePage> {
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

  T primeiroElemento<T>(List<T> itens) {
    return itens.first;
  }

  List<T> repetir<T>(T valor, int vezes) {
    return List.generate(vezes, (_) => valor);
  }

  Map<String, T> criarMapa<T>(T valor) {
    return {'valor': valor};
  }

  String descreverTipo<T>(T valor) {
    return 'Valor: $valor | Tipo: ${valor.runtimeType}';
  }

  String get conceitoCode => r'''
// T representa um tipo genérico

T primeiroElemento<T>(List<T> itens) {
  return itens.first;
}
// T funciona como um espaço reservado para um tipo real
// Quando a função for usada, T pode virar int, String, double etc.
''';

  String get funcaoGenericaCode => r'''
// Função genérica com T

T primeiroElemento<T>(List<T> itens) {
  return itens.first;
}

print(primeiroElemento<int>([10, 20, 30]));
// T vira int

print(primeiroElemento<String>(['a', 'b', 'c']));
// T vira String
''';

  String get inferenciaCode => r'''
// Inferência automática do tipo genérico

T primeiroElemento<T>(List<T> itens) {
  return itens.first;
}

print(primeiroElemento([10, 20, 30]));
// O Dart infere T como int

print(primeiroElemento(['a', 'b', 'c']));
// O Dart infere T como String
''';

  String get listaGenericaCode => r'''
// Lista genérica retornando T

List<T> repetir<T>(T valor, int vezes) {
  return List.generate(vezes, (_) => valor);
}

print(repetir<String>('oi', 3));
// Cria uma lista de String

print(repetir<int>(7, 4));
// Cria uma lista de int
''';

  String get mapaGenericoCode => r'''
// Map usando tipo genérico

Map<String, T> criarMapa<T>(T valor) {
  return {'valor': valor};
}

print(criarMapa<String>('Dart'));
// T vira String

print(criarMapa<double>(3.14));
// T vira double
''';

  String get tipoRuntimeCode => r'''
// Observando o tipo real em runtime

String descreverTipo<T>(T valor) {
  return 'Valor: $valor | Tipo: ${valor.runtimeType}';
}

print(descreverTipo<int>(10));
print(descreverTipo<String>('Ana'));
print(descreverTipo<bool>(true));
''';

  String get allCode => r'''
T primeiroElemento<T>(List<T> itens) {
  return itens.first;
}

List<T> repetir<T>(T valor, int vezes) {
  return List.generate(vezes, (_) => valor);
}

Map<String, T> criarMapa<T>(T valor) {
  return {'valor': valor};
}

print(primeiroElemento<int>([10, 20, 30]));
print(primeiroElemento<String>(['a', 'b', 'c']));
print(primeiroElemento([1.5, 2.5, 3.5]));

print(repetir<String>('oi', 3));
print(repetir<int>(7, 4));

print(criarMapa<String>('Dart'));
print(criarMapa<double>(3.14));
''';

  void runConceito() {
    runSection(
      title: "Conceito",
      code: conceitoCode,
      action: () {
        log("T é um tipo genérico.");
        log("Ele será substituído por um tipo real quando a função for usada.");
        log("Exemplos: int, String, double, bool.");
      },
    );
  }

  void runFuncaoGenerica() {
    runSection(
      title: "Função Genérica",
      code: funcaoGenericaCode,
      action: () {
        log(primeiroElemento<int>([10, 20, 30]));
        log(primeiroElemento<String>(['a', 'b', 'c']));
      },
    );
  }

  void runInferencia() {
    runSection(
      title: "Inferência de Tipo",
      code: inferenciaCode,
      action: () {
        log(primeiroElemento([10, 20, 30]));
        log(primeiroElemento(['a', 'b', 'c']));
      },
    );
  }

  void runListaGenerica() {
    runSection(
      title: "Lista Genérica",
      code: listaGenericaCode,
      action: () {
        log(repetir<String>('oi', 3));
        log(repetir<int>(7, 4));
      },
    );
  }

  void runMapaGenerico() {
    runSection(
      title: "Map Genérico",
      code: mapaGenericoCode,
      action: () {
        log(criarMapa<String>('Dart'));
        log(criarMapa<double>(3.14));
      },
    );
  }

  void runTipoRuntime() {
    runSection(
      title: "Tipo em Runtime",
      code: tipoRuntimeCode,
      action: () {
        log(descreverTipo<int>(10));
        log(descreverTipo<String>('Ana'));
        log(descreverTipo<bool>(true));
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    log(primeiroElemento<int>([10, 20, 30]));
    log(primeiroElemento<String>(['a', 'b', 'c']));
    log(primeiroElemento([1.5, 2.5, 3.5]));

    log(repetir<String>('oi', 3));
    log(repetir<int>(7, 4));

    log(criarMapa<String>('Dart'));
    log(criarMapa<double>(3.14));
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
      appBar: AppBar(title: const Text("T")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "T e Genéricos em Dart",
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
              title: "Conceito",
              description: "Entender o que significa T em tipos genéricos.",
              onRun: runConceito,
            ),
            buildSection(
              title: "Função Genérica",
              description: "Usar T em uma função que retorna o primeiro item.",
              onRun: runFuncaoGenerica,
            ),
            buildSection(
              title: "Inferência de Tipo",
              description: "Deixar o Dart descobrir automaticamente o tipo.",
              onRun: runInferencia,
            ),
            buildSection(
              title: "Lista Genérica",
              description: "Retornar listas tipadas com T.",
              onRun: runListaGenerica,
            ),
            buildSection(
              title: "Map Genérico",
              description: "Usar T como valor dentro de um Map.",
              onRun: runMapaGenerico,
            ),
            buildSection(
              title: "Tipo em Runtime",
              description: "Observar o tipo real dos valores usados com T.",
              onRun: runTipoRuntime,
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
