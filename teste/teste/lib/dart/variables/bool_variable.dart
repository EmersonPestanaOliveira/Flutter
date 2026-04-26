import 'package:flutter/material.dart';

class BoolVariablePage extends StatefulWidget {
  const BoolVariablePage({super.key});

  @override
  State<BoolVariablePage> createState() => _BoolVariablePageState();
}

class _BoolVariablePageState extends State<BoolVariablePage> {
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
// Declaração de variável booleana

bool ativo = true;
// Cria uma variável com valor verdadeiro

print(ativo);
// Exibe o valor no console
''';

  String get operadoresCode => r'''
// Operadores lógicos

bool a = true;
bool b = false;

print(a && b);
// AND lógico: verdadeiro somente se ambos forem true

print(a || b);
// OR lógico: verdadeiro se pelo menos um for true

print(!a);
// NOT lógico: inverte o valor
''';

  String get comparacoesCode => r'''
// Comparações geram valores booleanos

int x = 10;
int y = 5;

print(x > y);
// Verifica se x é maior que y

print(x < y);
// Verifica se x é menor que y

print(x == y);
// Verifica se os valores são iguais

print(x != y);
// Verifica se os valores são diferentes
''';

  String get condicionaisCode => r'''
// Uso de bool em estruturas condicionais

bool ativo = true;

if (ativo) {
  print("Usuário ativo");
}
// Executa o bloco se o valor for true

if (!ativo) {
  print("Usuário inativo");
}
// Executa se o valor for false
''';

  String get allCode => r'''
bool ativo = true;
print(ativo);

bool a = true;
bool b = false;

print(a && b);
print(a || b);
print(!a);

int x = 10;
int y = 5;

print(x > y);
print(x < y);
print(x == y);
print(x != y);

if (ativo) {
  print("Usuário ativo");
}
''';

  // ===============================
  // EXECUÇÃO
  // ===============================

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        bool ativo = true;

        log(ativo);
      },
    );
  }

  void runOperadores() {
    runSection(
      title: "Operadores Lógicos",
      code: operadoresCode,
      action: () {
        bool a = true;
        bool b = false;

        log(a && b);
        log(a || b);
        log(!a);
      },
    );
  }

  void runComparacoes() {
    runSection(
      title: "Comparações",
      code: comparacoesCode,
      action: () {
        int x = 10;
        int y = 5;

        log(x > y);
        log(x < y);
        log(x == y);
        log(x != y);
      },
    );
  }

  void runCondicionais() {
    runSection(
      title: "Condicionais",
      code: condicionaisCode,
      action: () {
        bool ativo = true;

        if (ativo) {
          log("Usuário ativo");
        }

        if (!ativo) {
          log("Usuário inativo");
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

    bool ativo = true;

    log(ativo);

    bool a = true;
    bool b = false;

    log(a && b);
    log(a || b);
    log(!a);

    int x = 10;
    int y = 5;

    log(x > y);
    log(x < y);
    log(x == y);
    log(x != y);

    if (ativo) {
      log("Usuário ativo");
    }
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
      appBar: AppBar(title: const Text("bool")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo bool em Dart",
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
              description: "Criar variáveis booleanas.",
              onRun: runDeclaracao,
            ),

            buildSection(
              title: "Operadores Lógicos",
              description: "AND, OR e NOT.",
              onRun: runOperadores,
            ),

            buildSection(
              title: "Comparações",
              description: "Operações que retornam verdadeiro ou falso.",
              onRun: runComparacoes,
            ),

            buildSection(
              title: "Condicionais",
              description: "Uso de bool em estruturas if.",
              onRun: runCondicionais,
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
