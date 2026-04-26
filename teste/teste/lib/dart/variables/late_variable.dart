import 'package:flutter/material.dart';

class LateVariablePage extends StatefulWidget {
  const LateVariablePage({super.key});

  @override
  State<LateVariablePage> createState() => _LateVariablePageState();
}

class _LateVariablePageState extends State<LateVariablePage> {
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

  String carregarMensagemComLog() {
    log('Carregando mensagem...');
    return 'Olá, Dart!';
  }

  String get declaracaoCode => r'''
// Declaração com late

late String mensagem;
// late permite declarar uma variável não nula
// que será inicializada depois

mensagem = 'Inicializada depois';
// A variável recebe valor antes de ser usada

print(mensagem);
// Exibe o valor armazenado
''';

  String get lazyCode => r'''
// Lazy initialization com late

String carregarMensagem() {
  print('Carregando mensagem...');
  return 'Olá, Dart!';
}

late String mensagemLazy = carregarMensagem();
// A função só será executada quando mensagemLazy
// for acessada pela primeira vez

print(mensagemLazy);
// Aqui acontece a inicialização

print(mensagemLazy);
// Na segunda vez, não carrega de novo
''';

  String get diferencaCode => r'''
// Diferença entre late comum e late lazy

late String nome;
// Só adia a obrigação de inicializar

late String valor = carregarMensagem();
// Além de adiar, também inicializa sob demanda

nome = 'Ana';

print(nome);
print(valor);
''';

  String get usoPraticoCode => r'''
// Uso prático de late

late String titulo;
// Variável será inicializada depois

titulo = 'Página inicial';
// Atribuição feita em outro momento

print(titulo);
// Exibe o valor quando já estiver pronto
''';

  String get erroCode => r'''
// Atenção: usar late sem inicializar gera erro

late String texto;
// Variável declarada mas ainda sem valor

// print(texto);
// Se tentar acessar antes de inicializar,
// ocorre LateInitializationError
''';

  String get allCode => r'''
late String mensagem;

String carregarMensagem() {
  print('Carregando mensagem...');
  return 'Olá, Dart!';
}

late String mensagemLazy = carregarMensagem();

mensagem = 'Inicializada depois';
print(mensagem);

print(mensagemLazy);
print(mensagemLazy);
''';

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        late String mensagem;
        mensagem = 'Inicializada depois';
        log(mensagem);
      },
    );
  }

  void runLazy() {
    runSection(
      title: "Lazy Initialization",
      code: lazyCode,
      action: () {
        late String mensagemLazy = carregarMensagemComLog();

        log(mensagemLazy);
        log(mensagemLazy);
      },
    );
  }

  void runDiferenca() {
    runSection(
      title: "Diferença de Uso",
      code: diferencaCode,
      action: () {
        late String nome;
        late String valor = carregarMensagemComLog();

        nome = 'Ana';

        log(nome);
        log(valor);
      },
    );
  }

  void runUsoPratico() {
    runSection(
      title: "Uso Prático",
      code: usoPraticoCode,
      action: () {
        late String titulo;
        titulo = 'Página inicial';
        log(titulo);
      },
    );
  }

  void runErro() {
    runSection(
      title: "Atenção ao Erro",
      code: erroCode,
      action: () {
        log(
          'Se acessar uma variável late antes de inicializar, ocorre LateInitializationError.',
        );
        log('Exemplo comentado no código para evitar erro real na tela.');
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    late String mensagem;
    late String mensagemLazy = carregarMensagemComLog();

    mensagem = 'Inicializada depois';
    log(mensagem);

    log(mensagemLazy);
    log(mensagemLazy);
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
      appBar: AppBar(title: const Text("late")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "late em Dart",
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
              description:
                  "Declarar uma variável que será inicializada depois.",
              onRun: runDeclaracao,
            ),
            buildSection(
              title: "Lazy Initialization",
              description:
                  "Inicializar somente quando a variável for acessada.",
              onRun: runLazy,
            ),
            buildSection(
              title: "Diferença de Uso",
              description: "Entender late comum e late com inicialização lazy.",
              onRun: runDiferenca,
            ),
            buildSection(
              title: "Uso Prático",
              description: "Exemplo simples de inicialização posterior.",
              onRun: runUsoPratico,
            ),
            buildSection(
              title: "Atenção ao Erro",
              description: "Entender o erro ao acessar late sem inicializar.",
              onRun: runErro,
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
