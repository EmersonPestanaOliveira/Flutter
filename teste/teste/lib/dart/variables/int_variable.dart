import 'package:flutter/material.dart';

class IntVariablePage extends StatefulWidget {
  const IntVariablePage({super.key});

  @override
  State<IntVariablePage> createState() => _IntVariablePageState();
}

class _IntVariablePageState extends State<IntVariablePage> {
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
// Declaração de inteiro

int x = -42;
// Cria uma variável inteira com valor negativo

print(x);
// Mostra o valor da variável no console
''';

  String get propriedadesCode => r'''
// Propriedades de int

int x = -42;

print(x.isEven);
// Verifica se o número é par

print(x.isOdd);
// Verifica se o número é ímpar

print(x.isNegative);
// Verifica se o número é negativo

print(x.bitLength);
// Quantidade de bits necessários para representar o número

print(x.sign);
// Retorna -1 negativo, 0 zero, 1 positivo
''';

  String get conversoesCode => r'''
// Conversões

int x = -42;

print(x.toDouble());
// Converte o inteiro para double

print(x.toString());
// Converte o inteiro para texto

print(x.toRadixString(2));
// Converte para representação binária

print(x.toRadixString(16));
// Converte para representação hexadecimal
''';

  String get matematicaCode => r'''
// Operações matemáticas

int x = -42;

print(x.abs());
// Valor absoluto

print(x.gcd(56));
// Máximo divisor comum entre x e 56

print(x.clamp(-10,10));
// Limita o valor dentro do intervalo
''';

  String get allCode => r'''
int x = -42;

// propriedades
print(x.isEven);
print(x.isOdd);
print(x.isNegative);
print(x.bitLength);
print(x.sign);

// conversões
print(x.toDouble());
print(x.toString());
print(x.toRadixString(2));
print(x.toRadixString(16));

// matemática
print(x.abs());
print(x.gcd(56));
print(x.clamp(-10,10));
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        int x = -42;
        log(x);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        int x = -42;

        log(x.isEven);
        log(x.isOdd);
        log(x.isNegative);
        log(x.bitLength);
        log(x.sign);
      },
    );
  }

  void runConversoes() {
    runSection(
      title: "Conversões",
      code: conversoesCode,
      action: () {
        int x = -42;

        log(x.toDouble());
        log(x.toString());
        log(x.toRadixString(2));
        log(x.toRadixString(16));
      },
    );
  }

  void runMatematica() {
    runSection(
      title: "Matemática",
      code: matematicaCode,
      action: () {
        int x = -42;

        log(x.abs());
        log(x.gcd(56));
        log(x.clamp(-10, 10));
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    int x = -42;

    log(x.isEven);
    log(x.isOdd);
    log(x.isNegative);
    log(x.bitLength);
    log(x.sign);

    log(x.toDouble());
    log(x.toString());
    log(x.toRadixString(2));
    log(x.toRadixString(16));

    log(x.abs());
    log(x.gcd(56));
    log(x.clamp(-10, 10));
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
      appBar: AppBar(title: const Text("int")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo int em Dart",
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
              description: "Criar e inicializar um número inteiro.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Propriedades",
              description: "Verifica características do número inteiro.",
              onRun: runPropriedades,
            ),

            buildSection(
              title: "Conversões",
              description: "Transforma int em outros formatos.",
              onRun: runConversoes,
            ),

            buildSection(
              title: "Matemática",
              description: "Operações matemáticas úteis com inteiros.",
              onRun: runMatematica,
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
