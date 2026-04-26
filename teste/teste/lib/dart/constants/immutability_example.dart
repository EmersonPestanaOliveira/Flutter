import 'package:flutter/material.dart';

class ImmutabilityExamplePage extends StatefulWidget {
  const ImmutabilityExamplePage({super.key});

  @override
  State<ImmutabilityExamplePage> createState() =>
      _ImmutabilityExamplePageState();
}

class _ImmutabilityExamplePageState extends State<ImmutabilityExamplePage> {
  final List<String> consoleOutput = [];

  String getCode() {
    return '''
void main() {
  const listaConst = [1, 2, 3];
  // listaConst.add(4); // Erro: lista imutável

  const mapaConst = {'a': 1, 'b': 2};
  // mapaConst['c'] = 3; // Erro: mapa imutável

  var lista = [1, 2, 3];
  var imutavel = List.unmodifiable(lista);

  // imutavel.add(4); // UnsupportedError
  lista.add(99);
  print(imutavel); // [1, 2, 3, 99]

  var mapa = {'a': 1};
  var imutavelMapa = Map.unmodifiable(mapa);

  // imutavelMapa['b'] = 2; // UnsupportedError
  mapa['a'] = 99;
  print(imutavelMapa); // {a: 99}
}
''';
  }

  void limparConsole() {
    setState(() {
      consoleOutput.clear();
    });
  }

  void executarListaConst() {
    setState(() {
      consoleOutput.clear();
      consoleOutput.add(">>> Lista const");
      consoleOutput.add("[1, 2, 3]");
      consoleOutput.add("Erro ao alterar: coleção const é imutável.");
    });
  }

  void executarMapaConst() {
    setState(() {
      consoleOutput.clear();
      consoleOutput.add(">>> Mapa const");
      consoleOutput.add("{a: 1, b: 2}");
      consoleOutput.add("Erro ao alterar: mapa const é imutável.");
    });
  }

  void executarListUnmodifiable() {
    setState(() {
      consoleOutput.clear();

      var lista = [1, 2, 3];
      var imutavel = List.unmodifiable(lista);

      consoleOutput.add(">>> List.unmodifiable");
      consoleOutput.add("Lista original: $lista");
      consoleOutput.add("Visão protegida: $imutavel");

      lista.add(99);

      consoleOutput.add("Após lista.add(99):");
      consoleOutput.add("Lista original: $lista");
      consoleOutput.add("Visão protegida: $imutavel");
      consoleOutput.add("A visão reflete a mudança da coleção original.");
    });
  }

  void executarMapUnmodifiable() {
    setState(() {
      consoleOutput.clear();

      var mapa = {'a': 1};
      var imutavelMapa = Map.unmodifiable(mapa);

      consoleOutput.add(">>> Map.unmodifiable");
      consoleOutput.add("Mapa original: $mapa");
      consoleOutput.add("Visão protegida: $imutavelMapa");

      mapa['a'] = 99;

      consoleOutput.add("Após mapa['a'] = 99:");
      consoleOutput.add("Mapa original: $mapa");
      consoleOutput.add("Visão protegida: $imutavelMapa");
      consoleOutput.add("A visão reflete a mudança do mapa original.");
    });
  }

  Widget secao(String titulo, String descricao, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(descricao, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onPressed, child: const Text("Executar")),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Imutabilidade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "const cria estruturas imutáveis. Já unmodifiable cria uma visão somente-leitura em tempo de execução.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Subtópicos abordados:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Lista const\n"
              "• Mapa const\n"
              "• List.unmodifiable\n"
              "• Map.unmodifiable\n"
              "• Diferença entre imutável em compilação e proteção em execução",
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
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            secao(
              "1. Lista const",
              "Coleções const são imutáveis e não podem ser alteradas.",
              executarListaConst,
            ),

            secao(
              "2. Mapa const",
              "Mapas const também não permitem alteração depois de criados.",
              executarMapaConst,
            ),

            secao(
              "3. List.unmodifiable",
              "Cria uma visão somente-leitura da lista em tempo de execução.",
              executarListUnmodifiable,
            ),

            secao(
              "4. Map.unmodifiable",
              "Cria uma visão protegida do mapa, mas a estrutura original ainda pode mudar.",
              executarMapUnmodifiable,
            ),

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
              "• const impede alteração da coleção.\n"
              "• List.unmodifiable e Map.unmodifiable impedem alteração pela referência protegida.\n"
              "• Se a coleção original mudar, a visão unmodifiable pode refletir essas mudanças.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
