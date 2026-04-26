import 'package:flutter/material.dart';

class NullSafetyVariablePage extends StatefulWidget {
  const NullSafetyVariablePage({super.key});

  @override
  State<NullSafetyVariablePage> createState() => _NullSafetyVariablePageState();
}

class _NullSafetyVariablePageState extends State<NullSafetyVariablePage> {
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

  String get tiposCode => r'''
// Tipos anuláveis e não anuláveis

String nome = 'Ana';
// String sem ? não aceita null

String? apelido;
// String com ? pode receber null

print(nome);
// Exibe o valor de nome

print(apelido);
// Como apelido ainda não recebeu valor, imprime null
''';

  String get atribuicaoCode => r'''
// Atribuição em variável anulável

String? apelido;
// Variável pode começar como null

apelido = 'Aninha';
// Agora recebe uma String

print(apelido);
// Exibe o novo valor
''';

  String get acessoSeguroCode => r'''
// Acesso seguro com ?.

String? apelido;
// Variável anulável

print(apelido?.length);
// ?. evita erro se o valor for null
// Nesse caso, retorna null

apelido = 'Aninha';
// Agora apelido tem valor

print(apelido?.length);
// Retorna o tamanho da string
''';

  String get forcarNaoNuloCode => r'''
// Forçando valor não nulo com !

String? apelido = 'Aninha';
// A variável recebe um valor

print(apelido!.length);
// ! afirma que apelido não é null
// Então o acesso ao length é permitido

// Se apelido fosse null aqui, daria erro em runtime
''';

  String get valorPadraoCode => r'''
// Valor padrão com ??

String? cidade;
// Variável anulável sem valor

print(cidade ?? 'Sem cidade');
// ?? usa o valor da esquerda se não for null
// Caso seja null, usa o valor da direita

cidade = 'Recife';
// Agora a variável recebe um valor

print(cidade ?? 'Sem cidade');
// Como cidade não é null, ela é exibida
''';

  String get comparacaoCode => r'''
// Comparação com null

String? apelido;
// Variável anulável

print(apelido == null);
// Verifica se o valor é null

apelido = 'Aninha';
// Atribui um valor

print(apelido == null);
// Agora o resultado será false
''';

  String get allCode => r'''
String nome = 'Ana';
String? apelido;

print(nome);
print(apelido);

apelido = 'Aninha';
print(apelido);

print(apelido?.length);
print(apelido!.length);

String? cidade;
print(cidade ?? 'Sem cidade');
''';

  void runTipos() {
    runSection(
      title: "Tipos Anuláveis e Não Anuláveis",
      code: tiposCode,
      action: () {
        String nome = 'Ana';
        String? apelido;

        log(nome);
        log(apelido);
      },
    );
  }

  void runAtribuicao() {
    runSection(
      title: "Atribuição",
      code: atribuicaoCode,
      action: () {
        String? apelido;
        apelido = 'Aninha';

        log(apelido);
      },
    );
  }

  void runAcessoSeguro() {
    runSection(
      title: "Acesso Seguro",
      code: acessoSeguroCode,
      action: () {
        String? apelido;
        log(apelido?.length);

        apelido = 'Aninha';
        log(apelido?.length);
      },
    );
  }

  void runForcarNaoNulo() {
    runSection(
      title: "Forçar Não Nulo",
      code: forcarNaoNuloCode,
      action: () {
        String? apelido = 'Aninha';
        log(apelido!.length);
      },
    );
  }

  void runValorPadrao() {
    runSection(
      title: "Valor Padrão",
      code: valorPadraoCode,
      action: () {
        String? cidade;
        log(cidade ?? 'Sem cidade');

        cidade = 'Recife';
        log(cidade ?? 'Sem cidade');
      },
    );
  }

  void runComparacao() {
    runSection(
      title: "Comparação com Null",
      code: comparacaoCode,
      action: () {
        String? apelido;
        log(apelido == null);

        apelido = 'Aninha';
        log(apelido == null);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    String nome = 'Ana';
    String? apelido;

    log(nome);
    log(apelido);

    apelido = 'Aninha';
    log(apelido);

    log(apelido?.length);
    log(apelido!.length);

    String? cidade;
    log(cidade ?? 'Sem cidade');
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
      appBar: AppBar(title: const Text("Null Safety")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Null Safety em Dart",
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
              title: "Tipos Anuláveis e Não Anuláveis",
              description: "Entender a diferença entre String e String?.",
              onRun: runTipos,
            ),
            buildSection(
              title: "Atribuição",
              description: "Atribuir valor a uma variável anulável.",
              onRun: runAtribuicao,
            ),
            buildSection(
              title: "Acesso Seguro",
              description: "Usar ?., evitando erro ao acessar valores nulos.",
              onRun: runAcessoSeguro,
            ),
            buildSection(
              title: "Forçar Não Nulo",
              description: "Usar ! para afirmar que o valor não é null.",
              onRun: runForcarNaoNulo,
            ),
            buildSection(
              title: "Valor Padrão",
              description: "Usar ?? para exibir um valor padrão.",
              onRun: runValorPadrao,
            ),
            buildSection(
              title: "Comparação com Null",
              description: "Verificar se uma variável está nula.",
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
