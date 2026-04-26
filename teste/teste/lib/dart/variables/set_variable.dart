import 'package:flutter/material.dart';

class SetVariablePage extends StatefulWidget {
  const SetVariablePage({super.key});

  @override
  State<SetVariablePage> createState() => _SetVariablePageState();
}

class _SetVariablePageState extends State<SetVariablePage> {
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

  String get criacaoCode => r'''
// Criação de sets

var conjunto1 = {1, 2, 3};
// Set com inferência de tipo int

Set<String> conjunto2 = {'a', 'b'};
// Set tipado de String

var vazio1 = <int>{};
// Set vazio tipado

var vazio2 = Set<int>();
// Outra forma de criar um Set vazio

var imutavel = Set.unmodifiable({1, 2, 3});
// Cria um Set que não pode ser alterado

print(conjunto1);
print(conjunto2);
print(vazio1);
print(vazio2);
print(imutavel);
''';

  String get propriedadesCode => r'''
// Propriedades do Set

var s = {10, 20, 30};
// Set usado para demonstrar propriedades

print(s.length);
// Quantidade de elementos

print(s.isEmpty);
// Verifica se está vazio

print(s.isNotEmpty);
// Verifica se não está vazio

print(s.first);
// Primeiro elemento

print(s.last);
// Último elemento
''';

  String get adicaoCode => r'''
// Adição de elementos

var s = {10, 20, 30};

s.add(40);
// Adiciona um novo elemento

s.addAll([50, 60]);
// Adiciona vários elementos

print(s);
''';

  String get remocaoCode => r'''
// Remoção de elementos

var s = {10, 20, 30, 40, 50, 60};

s.remove(20);
// Remove o valor 20

print(s);

s.removeWhere((e) => e > 40);
// Remove os elementos maiores que 40

print(s);

var limpar = {1, 2, 3};
limpar.clear();
// Remove todos os elementos

print(limpar);
''';

  String get verificacaoCode => r'''
// Verificação e busca

var c = {1, 2, 3};

print(c.contains(2));
// Verifica se o conjunto contém o valor 2

print(c.containsAll([1, 3]));
// Verifica se contém todos os valores informados
''';

  String get iteracaoCode => r'''
// Iteração

var c = {1, 2, 3};

for (var item in c) {
  print(item);
}
// Percorre todos os elementos com for-in

c.forEach((v) => print(v));
// Percorre todos os elementos com forEach
''';

  String get operacoesCode => r'''
// Operações de conjuntos

var a = {1, 2, 3};
var b = {3, 4, 5};

print(a.union(b));
// Junta os elementos dos dois conjuntos

print(a.intersection(b));
// Retorna apenas os elementos em comum

print(a.difference(b));
// Retorna os elementos que existem em a e não em b
''';

  String get transformacaoCode => r'''
// Transformação

var c = {1, 2, 3};

var dobrados = c.map((e) => e * 2).toSet();
// Cria um novo Set com os valores dobrados

var filtrado = c.where((e) => e.isEven).toSet();
// Filtra apenas os elementos pares

print(dobrados);
print(filtrado);
''';

  String get conversoesCode => r'''
// Conversões

var c = {1, 2, 3};

var lista = c.toList();
// Converte o Set em List

var copia = Set.from(c);
// Cria uma cópia do Set

var fixo = Set.identity();
// Cria um Set que compara objetos por identidade

fixo.add('a');
fixo.add('b');

print(lista);
print(copia);
print(fixo);
''';

  String get spreadCode => r'''
// Spread e null-aware spread

Set<int>? opcional;
// Set nulo

var s2 = {0, ...?opcional, 4};
// Só espalha o conteúdo se o Set não for nulo

print(s2);
''';

  String get allCode => r'''
var conjunto1 = {1, 2, 3};
Set<String> conjunto2 = {'a', 'b'};
var vazio1 = <int>{};
var vazio2 = Set<int>();
var imutavel = Set.unmodifiable({1, 2, 3});

print(conjunto1);
print(conjunto2);
print(vazio1);
print(vazio2);
print(imutavel);

var s = {10, 20, 30};
print(s.length);
print(s.first);
print(s.last);

s.add(40);
s.addAll([50, 60]);
print(s);

var c = {1, 2, 3};
print(c.contains(2));

var a = {1, 2, 3};
var b = {3, 4, 5};
print(a.union(b));
print(a.intersection(b));
print(a.difference(b));

var lista = c.toList();
print(lista);

Set<int>? opcional;
var s2 = {0, ...?opcional, 4};
print(s2);
''';

  void runCriacao() {
    runSection(
      title: "Criação",
      code: criacaoCode,
      action: () {
        var conjunto1 = {1, 2, 3};
        Set<String> conjunto2 = {'a', 'b'};
        var vazio1 = <int>{};
        var vazio2 = Set<int>();
        var imutavel = Set.unmodifiable({1, 2, 3});

        log(conjunto1);
        log(conjunto2);
        log(vazio1);
        log(vazio2);
        log(imutavel);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        var s = {10, 20, 30};

        log(s.length);
        log(s.isEmpty);
        log(s.isNotEmpty);
        log(s.first);
        log(s.last);
      },
    );
  }

  void runAdicao() {
    runSection(
      title: "Adição",
      code: adicaoCode,
      action: () {
        var s = {10, 20, 30};

        s.add(40);
        s.addAll([50, 60]);

        log(s);
      },
    );
  }

  void runRemocao() {
    runSection(
      title: "Remoção",
      code: remocaoCode,
      action: () {
        var s = {10, 20, 30, 40, 50, 60};

        s.remove(20);
        log(s);

        s.removeWhere((e) => e > 40);
        log(s);

        var limpar = {1, 2, 3};
        limpar.clear();
        log(limpar);
      },
    );
  }

  void runVerificacao() {
    runSection(
      title: "Verificação e Busca",
      code: verificacaoCode,
      action: () {
        var c = {1, 2, 3};

        log(c.contains(2));
        log(c.containsAll([1, 3]));
      },
    );
  }

  void runIteracao() {
    runSection(
      title: "Iteração",
      code: iteracaoCode,
      action: () {
        var c = {1, 2, 3};

        for (var item in c) {
          log(item);
        }

        c.forEach(log);
      },
    );
  }

  void runOperacoes() {
    runSection(
      title: "Operações de Conjuntos",
      code: operacoesCode,
      action: () {
        var a = {1, 2, 3};
        var b = {3, 4, 5};

        log(a.union(b));
        log(a.intersection(b));
        log(a.difference(b));
      },
    );
  }

  void runTransformacao() {
    runSection(
      title: "Transformação",
      code: transformacaoCode,
      action: () {
        var c = {1, 2, 3};

        var dobrados = c.map((e) => e * 2).toSet();
        var filtrado = c.where((e) => e.isEven).toSet();

        log(dobrados);
        log(filtrado);
      },
    );
  }

  void runConversoes() {
    runSection(
      title: "Conversões",
      code: conversoesCode,
      action: () {
        var c = {1, 2, 3};

        var lista = c.toList();
        var copia = Set.from(c);
        var fixo = Set.identity();

        fixo.add('a');
        fixo.add('b');

        log(lista);
        log(copia);
        log(fixo);
      },
    );
  }

  void runSpread() {
    runSection(
      title: "Spread",
      code: spreadCode,
      action: () {
        Set<int>? opcional;
        var s2 = {0, ...?opcional, 4};

        log(s2);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    var conjunto1 = {1, 2, 3};
    Set<String> conjunto2 = {'a', 'b'};
    var vazio1 = <int>{};
    var vazio2 = Set<int>();
    var imutavel = Set.unmodifiable({1, 2, 3});

    log(conjunto1);
    log(conjunto2);
    log(vazio1);
    log(vazio2);
    log(imutavel);

    var s = {10, 20, 30};
    log(s.length);
    log(s.first);
    log(s.last);

    s.add(40);
    s.addAll([50, 60]);
    log(s);

    var c = {1, 2, 3};
    log(c.contains(2));

    var a = {1, 2, 3};
    var b = {3, 4, 5};
    log(a.union(b));
    log(a.intersection(b));
    log(a.difference(b));

    var lista = c.toList();
    log(lista);

    Set<int>? opcional;
    var s2 = {0, ...?opcional, 4};
    log(s2);
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
      appBar: AppBar(title: const Text("Set")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo Set em Dart",
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
              title: "Criação",
              description: "Criar Sets tipados, vazios e imutáveis.",
              onRun: runCriacao,
            ),
            buildSection(
              title: "Propriedades",
              description: "Acessar tamanho, vazio, primeiro e último.",
              onRun: runPropriedades,
            ),
            buildSection(
              title: "Adição",
              description: "Adicionar um ou vários elementos.",
              onRun: runAdicao,
            ),
            buildSection(
              title: "Remoção",
              description: "Remover elementos, por condição e limpar.",
              onRun: runRemocao,
            ),
            buildSection(
              title: "Verificação e Busca",
              description: "Verificar existência de valores.",
              onRun: runVerificacao,
            ),
            buildSection(
              title: "Iteração",
              description: "Percorrer elementos com for-in e forEach.",
              onRun: runIteracao,
            ),
            buildSection(
              title: "Operações de Conjuntos",
              description: "Usar union, intersection e difference.",
              onRun: runOperacoes,
            ),
            buildSection(
              title: "Transformação",
              description: "Transformar e filtrar elementos.",
              onRun: runTransformacao,
            ),
            buildSection(
              title: "Conversões",
              description: "Converter para lista e copiar Sets.",
              onRun: runConversoes,
            ),
            buildSection(
              title: "Spread",
              description: "Combinar Sets com spread e null-aware spread.",
              onRun: runSpread,
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
