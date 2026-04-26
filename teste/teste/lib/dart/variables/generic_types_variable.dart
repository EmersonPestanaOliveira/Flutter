import 'package:flutter/material.dart';

class GenericTypesVariablePage extends StatefulWidget {
  const GenericTypesVariablePage({super.key});

  @override
  State<GenericTypesVariablePage> createState() =>
      _GenericTypesVariablePageState();
}

class _GenericTypesVariablePageState extends State<GenericTypesVariablePage> {
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

  String get conceitoCode => r'''
// Classe genérica com T

class Caixa<T> {
  T valor;
  // T representa um tipo genérico

  Caixa(this.valor);
  // Recebe um valor do tipo T

  void mostrar() {
    print(valor);
    // Exibe o valor armazenado
  }
}
// A mesma classe pode funcionar com int, String, double, etc.
''';

  String get classeGenericaCode => r'''
// Usando uma classe genérica

class Caixa<T> {
  T valor;

  Caixa(this.valor);

  void mostrar() {
    print(valor);
  }
}

var caixaInt = Caixa<int>(10);
// Aqui T vira int

var caixaString = Caixa<String>('Olá');
// Aqui T vira String

caixaInt.mostrar();
caixaString.mostrar();
''';

  String get listaGenericaCode => r'''
// List com tipo genérico

List<String> nomes = ['Ana', 'Bruno'];
// Lista que aceita apenas String

print(nomes);
// Exibe todos os nomes

print(nomes.first);
// Primeiro item da lista

print(nomes.runtimeType);
// Mostra o tipo da coleção em runtime
''';

  String get mapaGenericoCode => r'''
// Map com tipos genéricos

Map<String, int> idades = {
  'Ana': 20,
  'Bruno': 25,
};
// Chave é String, valor é int

print(idades);
// Exibe o mapa completo

print(idades['Ana']);
// Acessa o valor da chave Ana

print(idades.keys);
// Exibe todas as chaves

print(idades.values);
// Exibe todos os valores
''';

  String get reutilizacaoCode => r'''
// Reutilização com diferentes tipos

class Caixa<T> {
  T valor;

  Caixa(this.valor);

  void mostrar() {
    print(valor);
  }
}

var caixaDouble = Caixa<double>(3.14);
// Reutiliza a mesma classe com double

var caixaBool = Caixa<bool>(true);
// Reutiliza a mesma classe com bool

caixaDouble.mostrar();
caixaBool.mostrar();
''';

  String get segurancaCode => r'''
// Segurança de tipo

List<String> nomes = ['Ana', 'Bruno'];
// Essa lista só aceita String

print(nomes);

// nomes.add(10);
// Isso causaria erro de compilação,
// porque a lista foi definida como List<String>
''';

  String get allCode => r'''
class Caixa<T> {
  T valor;

  Caixa(this.valor);

  void mostrar() {
    print(valor);
  }
}

var caixaInt = Caixa<int>(10);
var caixaString = Caixa<String>('Olá');

caixaInt.mostrar();
caixaString.mostrar();

List<String> nomes = ['Ana', 'Bruno'];
Map<String, int> idades = {
  'Ana': 20,
  'Bruno': 25,
};

print(nomes);
print(idades);
''';

  void runConceito() {
    runSection(
      title: "Conceito",
      code: conceitoCode,
      action: () {
        log("Tipos genéricos usam um espaço reservado como T.");
        log("Esse tipo é substituído por um tipo real depois.");
        log("Exemplos: int, String, double, bool.");
      },
    );
  }

  void runClasseGenerica() {
    runSection(
      title: "Classe Genérica",
      code: classeGenericaCode,
      action: () {
        final caixaInt = Caixa<int>(10);
        final caixaString = Caixa<String>('Olá');

        log(caixaInt.valor);
        log(caixaString.valor);
      },
    );
  }

  void runListaGenerica() {
    runSection(
      title: "List Genérica",
      code: listaGenericaCode,
      action: () {
        List<String> nomes = ['Ana', 'Bruno'];

        log(nomes);
        log(nomes.first);
        log(nomes.runtimeType);
      },
    );
  }

  void runMapaGenerico() {
    runSection(
      title: "Map Genérico",
      code: mapaGenericoCode,
      action: () {
        Map<String, int> idades = {'Ana': 20, 'Bruno': 25};

        log(idades);
        log(idades['Ana']);
        log(idades.keys.toList());
        log(idades.values.toList());
      },
    );
  }

  void runReutilizacao() {
    runSection(
      title: "Reutilização",
      code: reutilizacaoCode,
      action: () {
        final caixaDouble = Caixa<double>(3.14);
        final caixaBool = Caixa<bool>(true);

        log(caixaDouble.valor);
        log(caixaBool.valor);
      },
    );
  }

  void runSeguranca() {
    runSection(
      title: "Segurança de Tipo",
      code: segurancaCode,
      action: () {
        List<String> nomes = ['Ana', 'Bruno'];

        log(nomes);
        log("A lista aceita apenas String.");
        log("Adicionar int causaria erro de compilação.");
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    final caixaInt = Caixa<int>(10);
    final caixaString = Caixa<String>('Olá');

    log(caixaInt.valor);
    log(caixaString.valor);

    List<String> nomes = ['Ana', 'Bruno'];
    Map<String, int> idades = {'Ana': 20, 'Bruno': 25};

    log(nomes);
    log(idades);
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
      appBar: AppBar(title: const Text("Tipos Genéricos")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipos Genéricos em Dart",
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
              title: "Conceito",
              description: "Entender o que são tipos genéricos e o papel do T.",
              onRun: runConceito,
            ),
            buildSection(
              title: "Classe Genérica",
              description: "Criar e usar uma classe reutilizável com T.",
              onRun: runClasseGenerica,
            ),
            buildSection(
              title: "List Genérica",
              description: "Usar List<String> para segurança de tipo.",
              onRun: runListaGenerica,
            ),
            buildSection(
              title: "Map Genérico",
              description: "Usar Map<String, int> com chave e valor tipados.",
              onRun: runMapaGenerico,
            ),
            buildSection(
              title: "Reutilização",
              description: "Usar a mesma classe genérica com tipos diferentes.",
              onRun: runReutilizacao,
            ),
            buildSection(
              title: "Segurança de Tipo",
              description: "Entender como genéricos evitam erros de tipo.",
              onRun: runSeguranca,
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

class Caixa<T> {
  T valor;

  Caixa(this.valor);

  void mostrar() {
    // Mantido por compatibilidade com o exemplo original
    // Nesta tela o valor é exibido pelo console simulado
  }
}
