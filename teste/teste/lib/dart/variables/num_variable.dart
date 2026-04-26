import 'package:flutter/material.dart';

class NumVariablePage extends StatefulWidget {
  const NumVariablePage({super.key});

  @override
  State<NumVariablePage> createState() => _NumVariablePageState();
}

class _NumVariablePageState extends State<NumVariablePage> {
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
// Declaração do tipo num

num n = -3.5;
// num pode armazenar tanto int quanto double

print(n);
// Exibe o valor da variável
''';

  String get propriedadesCode => r'''
// Propriedades do tipo num

num n = -3.5;

print(n.isNegative);
// Verifica se o número é negativo

print(n.isFinite);
// Verifica se o número é finito

print(n.isInfinite);
// Verifica se é infinito

print(n.isNaN);
// Verifica se é "Not a Number"

print(n.sign);
// Retorna o sinal do número (-1, 0 ou 1)
''';

  String get conversoesCode => r'''
// Conversões

num n = -3.5;

print(n.toInt());
// Converte para inteiro

print(n.toDouble());
// Converte para número decimal

print(n.toString());
// Converte para texto

print(n.toStringAsFixed(1));
// Define quantidade fixa de casas decimais

print(n.toStringAsPrecision(3));
// Define quantidade total de dígitos

print(n.toStringAsExponential(2));
// Converte para notação científica
''';

  String get matematicaCode => r'''
// Operações matemáticas

num n = -3.5;

print(n.abs());
// Valor absoluto

print(n.ceil());
// Arredonda para cima

print(n.floor());
// Arredonda para baixo

print(n.round());
// Arredonda para inteiro mais próximo

print(n.truncate());
// Remove parte decimal

print(n.clamp(-2, 2));
// Limita o valor dentro do intervalo
''';

  String get arredondamentoDoubleCode => r'''
// Arredondamentos retornando double

num n = -3.5;

print(n.ceilToDouble());
// Arredonda para cima mantendo double

print(n.floorToDouble());
// Arredonda para baixo mantendo double

print(n.roundToDouble());
// Arredonda para inteiro mais próximo

print(n.truncateToDouble());
// Remove parte decimal mantendo double
''';

  String get allCode => r'''
num n = -3.5;

// propriedades
print(n.isNegative);
print(n.isFinite);
print(n.isInfinite);
print(n.isNaN);
print(n.sign);

// conversões
print(n.toInt());
print(n.toDouble());
print(n.toString());
print(n.toStringAsFixed(1));
print(n.toStringAsPrecision(3));
print(n.toStringAsExponential(2));

// matemática
print(n.abs());
print(n.ceil());
print(n.floor());
print(n.round());
print(n.truncate());
print(n.clamp(-2, 2));

// arredondamentos double
print(n.ceilToDouble());
print(n.floorToDouble());
print(n.roundToDouble());
print(n.truncateToDouble());
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        num n = -3.5;
        log(n);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        num n = -3.5;

        log(n.isNegative);
        log(n.isFinite);
        log(n.isInfinite);
        log(n.isNaN);
        log(n.sign);
      },
    );
  }

  void runConversoes() {
    runSection(
      title: "Conversões",
      code: conversoesCode,
      action: () {
        num n = -3.5;

        log(n.toInt());
        log(n.toDouble());
        log(n.toString());
        log(n.toStringAsFixed(1));
        log(n.toStringAsPrecision(3));
        log(n.toStringAsExponential(2));
      },
    );
  }

  void runMatematica() {
    runSection(
      title: "Matemática",
      code: matematicaCode,
      action: () {
        num n = -3.5;

        log(n.abs());
        log(n.ceil());
        log(n.floor());
        log(n.round());
        log(n.truncate());
        log(n.clamp(-2, 2));
      },
    );
  }

  void runArredondamentoDouble() {
    runSection(
      title: "Arredondamento Double",
      code: arredondamentoDoubleCode,
      action: () {
        num n = -3.5;

        log(n.ceilToDouble());
        log(n.floorToDouble());
        log(n.roundToDouble());
        log(n.truncateToDouble());
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    num n = -3.5;

    log(n.isNegative);
    log(n.isFinite);
    log(n.isInfinite);
    log(n.isNaN);
    log(n.sign);

    log(n.toInt());
    log(n.toDouble());
    log(n.toString());
    log(n.toStringAsFixed(1));
    log(n.toStringAsPrecision(3));
    log(n.toStringAsExponential(2));

    log(n.abs());
    log(n.ceil());
    log(n.floor());
    log(n.round());
    log(n.truncate());
    log(n.clamp(-2, 2));

    log(n.ceilToDouble());
    log(n.floorToDouble());
    log(n.roundToDouble());
    log(n.truncateToDouble());
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
      appBar: AppBar(title: const Text("num")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo num em Dart",
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
              description: "Cria números que podem ser int ou double.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Propriedades",
              description: "Verifica características do número.",
              onRun: runPropriedades,
            ),

            buildSection(
              title: "Conversões",
              description: "Transforma num em int, double ou texto.",
              onRun: runConversoes,
            ),

            buildSection(
              title: "Matemática",
              description: "Operações matemáticas comuns.",
              onRun: runMatematica,
            ),

            buildSection(
              title: "Arredondamento Double",
              description: "Arredondamentos retornando double.",
              onRun: runArredondamentoDouble,
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
