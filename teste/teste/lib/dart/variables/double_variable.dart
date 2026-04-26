import 'package:flutter/material.dart';

class DoubleVariablePage extends StatefulWidget {
  const DoubleVariablePage({super.key});

  @override
  State<DoubleVariablePage> createState() => _DoubleVariablePageState();
}

class _DoubleVariablePageState extends State<DoubleVariablePage> {
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
// Declaração de número decimal

double x = -3.14;
// Cria um número decimal negativo

print(x);
// Mostra o valor no console
''';

  String get propriedadesCode => r'''
// Propriedades de double

double x = -3.14;

print(x.isNaN);
// Verifica se é NaN (Not a Number)

print(x.isInfinite);
// Verifica se é infinito

print(x.isFinite);
// Verifica se é um número finito

print(x.isNegative);
// Verifica se o número é negativo

print(x.sign);
// Retorna o sinal do número (-1.0, 0.0 ou 1.0)
''';

  String get conversoesCode => r'''
// Conversões

double x = -3.14;

print(x.toInt());
// Converte para inteiro

print(x.toString());
// Converte para texto

print(x.toStringAsFixed(1));
// Define quantidade fixa de casas decimais

print(x.toStringAsPrecision(3));
// Define quantidade total de dígitos

print(x.toStringAsExponential(2));
// Converte para notação científica
''';

  String get matematicaCode => r'''
// Operações matemáticas

double x = -3.14;

print(x.abs());
// Valor absoluto

print(x.ceil());
// Arredonda para cima

print(x.floor());
// Arredonda para baixo

print(x.round());
// Arredonda para inteiro mais próximo

print(x.truncate());
// Remove parte decimal
''';

  String get arredondamentoDoubleCode => r'''
// Arredondamentos retornando double

double x = -3.14;

print(x.ceilToDouble());
// Arredonda para cima mantendo double

print(x.floorToDouble());
// Arredonda para baixo mantendo double

print(x.roundToDouble());
// Arredonda para inteiro mais próximo

print(x.truncateToDouble());
// Remove parte decimal mantendo double
''';

  String get constantesCode => r'''
// Constantes especiais de double

print(double.nan);
// Representa "Not a Number"

print(double.infinity);
// Representa infinito positivo

print(double.negativeInfinity);
// Representa infinito negativo

print(double.minPositive);
// Menor número positivo possível

print(double.maxFinite);
// Maior número finito possível
''';

  String get allCode => r'''
double x = -3.14;

// propriedades
print(x.isNaN);
print(x.isInfinite);
print(x.isFinite);
print(x.isNegative);
print(x.sign);

// conversões
print(x.toInt());
print(x.toString());
print(x.toStringAsFixed(1));
print(x.toStringAsPrecision(3));
print(x.toStringAsExponential(2));

// matemática
print(x.abs());
print(x.ceil());
print(x.floor());
print(x.round());
print(x.truncate());

// arredondamento double
print(x.ceilToDouble());
print(x.floorToDouble());
print(x.roundToDouble());
print(x.truncateToDouble());

// constantes
print(double.nan);
print(double.infinity);
print(double.negativeInfinity);
print(double.minPositive);
print(double.maxFinite);
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        double x = -3.14;
        log(x);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        double x = -3.14;

        log(x.isNaN);
        log(x.isInfinite);
        log(x.isFinite);
        log(x.isNegative);
        log(x.sign);
      },
    );
  }

  void runConversoes() {
    runSection(
      title: "Conversões",
      code: conversoesCode,
      action: () {
        double x = -3.14;

        log(x.toInt());
        log(x.toString());
        log(x.toStringAsFixed(1));
        log(x.toStringAsPrecision(3));
        log(x.toStringAsExponential(2));
      },
    );
  }

  void runMatematica() {
    runSection(
      title: "Matemática",
      code: matematicaCode,
      action: () {
        double x = -3.14;

        log(x.abs());
        log(x.ceil());
        log(x.floor());
        log(x.round());
        log(x.truncate());
      },
    );
  }

  void runArredondamentoDouble() {
    runSection(
      title: "Arredondamento Double",
      code: arredondamentoDoubleCode,
      action: () {
        double x = -3.14;

        log(x.ceilToDouble());
        log(x.floorToDouble());
        log(x.roundToDouble());
        log(x.truncateToDouble());
      },
    );
  }

  void runConstantes() {
    runSection(
      title: "Constantes",
      code: constantesCode,
      action: () {
        log(double.nan);
        log(double.infinity);
        log(double.negativeInfinity);
        log(double.minPositive);
        log(double.maxFinite);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    double x = -3.14;

    log(x.isNaN);
    log(x.isInfinite);
    log(x.isFinite);
    log(x.isNegative);
    log(x.sign);

    log(x.toInt());
    log(x.toString());
    log(x.toStringAsFixed(1));
    log(x.toStringAsPrecision(3));
    log(x.toStringAsExponential(2));

    log(x.abs());
    log(x.ceil());
    log(x.floor());
    log(x.round());
    log(x.truncate());

    log(x.ceilToDouble());
    log(x.floorToDouble());
    log(x.roundToDouble());
    log(x.truncateToDouble());

    log(double.nan);
    log(double.infinity);
    log(double.negativeInfinity);
    log(double.minPositive);
    log(double.maxFinite);
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
      appBar: AppBar(title: const Text("double")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo double em Dart",
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
              description: "Criar números decimais.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Propriedades",
              description: "Verifica características do número decimal.",
              onRun: runPropriedades,
            ),

            buildSection(
              title: "Conversões",
              description: "Transforma double em outros formatos.",
              onRun: runConversoes,
            ),

            buildSection(
              title: "Matemática",
              description: "Operações matemáticas com números decimais.",
              onRun: runMatematica,
            ),

            buildSection(
              title: "Arredondamento Double",
              description: "Arredondamentos retornando double.",
              onRun: runArredondamentoDouble,
            ),

            buildSection(
              title: "Constantes",
              description: "Valores especiais de double.",
              onRun: runConstantes,
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
