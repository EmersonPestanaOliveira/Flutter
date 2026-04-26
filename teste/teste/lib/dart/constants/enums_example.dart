import 'package:flutter/material.dart';

class EnumsExamplePage extends StatefulWidget {
  const EnumsExamplePage({super.key});

  @override
  State<EnumsExamplePage> createState() => _EnumsExamplePageState();
}

class _EnumsExamplePageState extends State<EnumsExamplePage> {
  final List<String> consoleOutput = [];

  void limparConsole() {
    setState(() {
      consoleOutput.clear();
    });
  }

  void executarValores() {
    setState(() {
      consoleOutput.clear();

      var c = Cor.verde;

      consoleOutput.add(">>> Acessando valores");
      consoleOutput.add(c.toString());
      consoleOutput.add(c.name);
      consoleOutput.add(Cor.values.toString());
    });
  }

  void executarLoop() {
    setState(() {
      consoleOutput.clear();

      consoleOutput.add(">>> Iterando enum");

      for (var cor in Cor.values) {
        consoleOutput.add("${cor.index} - ${cor.name}");
      }
    });
  }

  void executarSwitch() {
    setState(() {
      consoleOutput.clear();

      consoleOutput.add(">>> Switch com enum");

      var cor = Cor.verde;

      switch (cor) {
        case Cor.vermelho:
          consoleOutput.add("Pare");
          break;
        case Cor.verde:
          consoleOutput.add("Siga");
          break;
        case Cor.azul:
          consoleOutput.add("Aviso");
          break;
      }
    });
  }

  void executarEnumAvancado() {
    setState(() {
      consoleOutput.clear();

      consoleOutput.add(">>> Enum com atributos");

      var s = Status.emAndamento;

      consoleOutput.add(s.descricao);
      consoleOutput.add("Status: ${s.descricao}");

      var corPorNome = Cor.values.byName("verde");
      consoleOutput.add(corPorNome.toString());
    });
  }

  String getCode() {
    return '''
enum Cor { vermelho, verde, azul }

enum Status {
  pendente("Aguardando"),
  emAndamento("Processando"),
  concluido("Finalizado");

  final String descricao;

  const Status(this.descricao);

  void log() => print('Status: \$descricao');
}
''';
  }

  Widget secao(String titulo, VoidCallback executar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: executar, child: const Text("Executar")),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enums")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enums definem um conjunto fixo de valores nomeados.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getCode(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            const SizedBox(height: 20),

            secao("1. Acessando valores", executarValores),
            secao("2. Iterando enums", executarLoop),
            secao("3. Switch com enum", executarSwitch),
            secao("4. Enum com atributos", executarEnumAvancado),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: limparConsole,
              child: const Text("Limpar console"),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: consoleOutput.isEmpty
                  ? const Text(
                      "Console vazio.",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: consoleOutput.map((linha) {
                        return Text(
                          linha,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Cor { vermelho, verde, azul }

enum Status {
  pendente("Aguardando"),
  emAndamento("Processando"),
  concluido("Finalizado");

  final String descricao;

  const Status(this.descricao);
}
