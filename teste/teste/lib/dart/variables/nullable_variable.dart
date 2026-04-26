import 'package:flutter/material.dart';

class NullableVariablePage extends StatefulWidget {
  const NullableVariablePage({super.key});

  @override
  State<NullableVariablePage> createState() => _NullableVariablePageState();
}

class _NullableVariablePageState extends State<NullableVariablePage> {
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

  String get declaracaoCode => r'''
// Variável nullable

String? nome;
// O ? indica que a variável pode ser null

print(nome);
// Como ainda não recebeu valor, o resultado será null

nome = "Fernanda";
// Agora a variável recebe uma String

print(nome);
// Exibe o novo valor
''';

  String get verificacaoCode => r'''
// Verificação de null

String? nome;
// Variável começa como null

print(nome == null);
// Verifica se a variável é nula

nome = "Fernanda";
// Atribui um valor

print(nome == null);
// Agora não é mais null
''';

  String get nullAwareCode => r'''
// Operadores null-aware

String? nome;
// Variável nula

print(nome?.length);
// ?. evita erro e retorna null se nome for null

print(nome ?? "Sem nome");
// ?? usa um valor padrão se a variável for null

nome = "Fernanda";
// Atribui um valor

print(nome?.length);
// Agora retorna o tamanho da string

print(nome ?? "Sem nome");
// Como nome tem valor, ele é exibido
''';

  String get atribuicaoPadraoCode => r'''
// Atribuição com valor padrão

String? nome;
// Variável nullable

var resultado = nome ?? "Visitante";
// Se nome for null, usa "Visitante"

print(resultado);

nome = "Fernanda";
// Agora a variável tem valor

resultado = nome ?? "Visitante";
// Como nome não é null, usa o valor real

print(resultado);
''';

  String get allCode => r'''
String? nome;
print(nome);

nome = "Fernanda";
print(nome);

print(nome == null);

print(nome?.length);
print(nome ?? "Sem nome");

String? cidade;
print(cidade ?? "Não informada");
''';

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        String? nome;
        log(nome);

        nome = "Fernanda";
        log(nome);
      },
    );
  }

  void runVerificacao() {
    runSection(
      title: "Verificação de Null",
      code: verificacaoCode,
      action: () {
        String? nome;
        log(nome == null);

        nome = "Fernanda";
        log(nome == null);
      },
    );
  }

  void runNullAware() {
    runSection(
      title: "Operadores Null-aware",
      code: nullAwareCode,
      action: () {
        String? nome;
        log(nome?.length);
        log(nome ?? "Sem nome");

        nome = "Fernanda";
        log(nome?.length);
        log(nome ?? "Sem nome");
      },
    );
  }

  void runAtribuicaoPadrao() {
    runSection(
      title: "Valor Padrão",
      code: atribuicaoPadraoCode,
      action: () {
        String? nome;
        var resultado = nome ?? "Visitante";
        log(resultado);

        nome = "Fernanda";
        resultado = nome ?? "Visitante";
        log(resultado);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    String? nome;
    log(nome);

    nome = "Fernanda";
    log(nome);

    log(nome == null);

    log(nome?.length);
    log(nome ?? "Sem nome");

    String? cidade;
    log(cidade ?? "Não informada");
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
      appBar: AppBar(title: const Text("Nullable")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nullable em Dart",
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
              description: "Criar uma variável que pode receber null.",
              onRun: runDeclaracao,
            ),
            buildSection(
              title: "Verificação de Null",
              description: "Verificar se a variável está nula.",
              onRun: runVerificacao,
            ),
            buildSection(
              title: "Operadores Null-aware",
              description: "Usar ?., ?? e acesso seguro com valores nulos.",
              onRun: runNullAware,
            ),
            buildSection(
              title: "Valor Padrão",
              description:
                  "Definir um valor padrão quando a variável for null.",
              onRun: runAtribuicaoPadrao,
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
