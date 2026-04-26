import 'package:flutter/material.dart';

class FinalExamplePage extends StatefulWidget {
  const FinalExamplePage({super.key});

  @override
  State<FinalExamplePage> createState() => _FinalExamplePageState();
}

class _FinalExamplePageState extends State<FinalExamplePage> {
  final List<String> consoleOutput = [];

  String getCode() {
    return '''
void main() {
  final int constanteTempoExecucao = DateTime.now().year;
  print(constanteTempoExecucao);
}
''';
  }

  void executarCodigo() {
    final int constanteTempoExecucao = DateTime.now().year;

    setState(() {
      consoleOutput.clear();
      consoleOutput.add(">>> Executando main()");
      consoleOutput.add("$constanteTempoExecucao");
      consoleOutput.add("Process finished.");
    });
  }

  void limparConsole() {
    setState(() {
      consoleOutput.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("final")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Constante no tempo de execução",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "Uma variável final recebe valor apenas uma vez, mas esse valor pode ser definido durante a execução.",
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

            const Text(
              "Interação prática:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: executarCodigo,
                    child: const Text("Executar código"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: limparConsole,
                    child: const Text("Limpar console"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 140),
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            linha,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Resumo:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "• final é definido uma única vez.\n"
              "• O valor pode ser descoberto em tempo de execução.\n"
              "• Depois de atribuído, não pode ser alterado.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
