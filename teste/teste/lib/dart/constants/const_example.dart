import 'package:flutter/material.dart';

class ConstExamplePage extends StatefulWidget {
  const ConstExamplePage({super.key});

  @override
  State<ConstExamplePage> createState() => _ConstExamplePageState();
}

class _ConstExamplePageState extends State<ConstExamplePage> {
  final List<String> consoleOutput = [];

  String getCode() {
    return '''
const int constanteTempoCompilacao = 10;

void main() {
  print(constanteTempoCompilacao);
}
''';
  }

  void executarCodigo() {
    const int constanteTempoCompilacao = 10;

    setState(() {
      consoleOutput.clear();
      consoleOutput.add("> Executando código...");
      consoleOutput.add("$constanteTempoCompilacao");
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
      appBar: AppBar(title: const Text("const")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Constante no tempo de compilação",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "Uma variável const deve ter um valor conhecido durante a compilação.",
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
              constraints: const BoxConstraints(minHeight: 120),
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

            const SizedBox(height: 20),

            const Text(
              "Resumo:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "• const é avaliado em tempo de compilação.\n"
              "• O valor não pode mudar.\n"
              "• Muito usado quando o valor já é conhecido antes da execução.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
