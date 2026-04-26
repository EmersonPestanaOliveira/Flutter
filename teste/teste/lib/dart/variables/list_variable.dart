import 'package:flutter/material.dart';

class ListVariablePage extends StatefulWidget {
  const ListVariablePage({super.key});

  @override
  State<ListVariablePage> createState() => _ListVariablePageState();
}

class _ListVariablePageState extends State<ListVariablePage> {
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
// Criação de listas

var lista1 = [1, 2, 3];
// Lista com inferência de tipo int

List<String> lista2 = ['a', 'b'];
// Lista tipada de String

var listaVazia = <int>[];
// Lista vazia tipada

var listaFixa = List.filled(3, 0);
// Cria uma lista com 3 posições preenchidas com 0

var listaGerada = List.generate(5, (i) => i * 2);
// Gera 5 itens com base no índice

print(lista1);
print(lista2);
print(listaVazia);
print(listaFixa);
print(listaGerada);
''';

  String get propriedadesCode => r'''
// Propriedades de List

var l = [10, 20, 30];
// Lista usada para demonstrar propriedades

print(l.length);
// Quantidade de elementos

print(l.isEmpty);
// Verifica se a lista está vazia

print(l.isNotEmpty);
// Verifica se a lista não está vazia

print(l.first);
// Primeiro elemento

print(l.last);
// Último elemento

print(l.reversed);
// Retorna os elementos em ordem reversa
''';

  String get adicaoInsercaoCode => r'''
// Adição e inserção

var l = [10, 20, 30];

l.add(40);
// Adiciona um item no final

l.addAll([50, 60]);
// Adiciona vários itens no final

l.insert(1, 15);
// Insere 15 no índice 1

l.insertAll(2, [16, 17]);
// Insere vários itens a partir do índice 2

print(l);
''';

  String get remocaoCode => r'''
// Remoção de itens

var remocoes = [10, 20, 30, 20, 40];

remocoes.remove(20);
// Remove a primeira ocorrência de 20

print(remocoes);

remocoes.removeAt(0);
// Remove o item do índice 0

print(remocoes);

remocoes.removeLast();
// Remove o último item

print(remocoes);

remocoes.removeRange(0, 2);
// Remove um intervalo de índices

print(remocoes);

remocoes.clear();
// Remove todos os itens

print(remocoes);
''';

  String get buscaCode => r'''
// Busca e verificação

var nums = [10, 20, 30, 20];

print(nums.contains(20));
// Verifica se a lista contém o valor 20

print(nums.indexOf(20));
// Retorna o índice da primeira ocorrência

print(nums.lastIndexOf(20));
// Retorna o índice da última ocorrência

print(nums.elementAt(2));
// Retorna o elemento do índice 2
''';

  String get iteracaoCode => r'''
// Iteração

var nums = [10, 20, 30, 20];

for (var item in nums) {
  print(item);
}
// Percorre todos os elementos com for-in

nums.forEach((n) => print(n));
// Percorre todos os elementos com forEach
''';

  String get transformacaoCode => r'''
// Transformação

var nums = [10, 20, 30, 20];

var dobrados = nums.map((n) => n * 2).toList();
// Cria uma nova lista com valores dobrados

var pares = nums.where((n) => n.isEven).toList();
// Filtra apenas números pares

var primeiroGrande = nums.firstWhere(
  (n) => n > 15,
  orElse: () => -1,
);
// Retorna o primeiro valor maior que 15

var soma = nums.reduce((a, b) => a + b);
// Soma todos os elementos, sem valor inicial

var acumulado = nums.fold(100, (a, b) => a + b);
// Soma todos os elementos começando de 100

print(dobrados);
print(pares);
print(primeiroGrande);
print(soma);
print(acumulado);
''';

  String get ordenacaoCode => r'''
// Ordenação

var ordenacao = [30, 10, 20, 5];

ordenacao.sort();
// Ordena em ordem crescente

print(ordenacao);

ordenacao.sort((a, b) => b.compareTo(a));
// Ordena em ordem decrescente

print(ordenacao);
''';

  String get copiaPartesCode => r'''
// Cópia e partes da lista

var nums = [10, 20, 30, 20];

var copia = List.from(nums);
// Cria uma cópia mutável da lista

var imutavel = List.unmodifiable(nums);
// Cria uma versão que não pode ser alterada

var sub = nums.sublist(1, 3);
// Extrai parte da lista do índice 1 até antes do 3

print(copia);
print(imutavel);
print(sub);
''';

  String get intervaloCode => r'''
// Manipulação por intervalo

var intervalo = [1, 2, 3, 4];

intervalo.fillRange(1, 3, 99);
// Preenche do índice 1 até antes do 3 com 99

print(intervalo);

intervalo.replaceRange(0, 2, [7, 8]);
// Substitui o intervalo por novos valores

print(intervalo);
''';

  String get spreadCode => r'''
// Spread e null-aware spread

var a = [1, 2];

var b = [0, ...a, 3];
// Insere os elementos de a dentro de b

print(b);

List<int>? c;
// Lista nula

var d = [0, ...?c, 3];
// Só espalha os elementos se c não for nula

print(d);
''';

  String get allCode => r'''
var lista1 = [1, 2, 3];
List<String> lista2 = ['a', 'b'];
var listaVazia = <int>[];
var listaFixa = List.filled(3, 0);
var listaGerada = List.generate(5, (i) => i * 2);

print(lista1);
print(lista2);
print(listaVazia);
print(listaFixa);
print(listaGerada);

var l = [10, 20, 30];
print(l.length);
print(l.first);
print(l.last);

l.add(40);
l.insert(1, 15);
print(l);

var nums = [10, 20, 30, 20];
print(nums.contains(20));
print(nums.indexOf(20));

var dobrados = nums.map((n) => n * 2).toList();
print(dobrados);

var ordenacao = [30, 10, 20, 5];
ordenacao.sort();
print(ordenacao);

var a = [1, 2];
var b = [0, ...a, 3];
print(b);
''';

  void runCriacao() {
    runSection(
      title: "Criação",
      code: criacaoCode,
      action: () {
        var lista1 = [1, 2, 3];
        List<String> lista2 = ['a', 'b'];
        var listaVazia = <int>[];
        var listaFixa = List.filled(3, 0);
        var listaGerada = List.generate(5, (i) => i * 2);

        log(lista1);
        log(lista2);
        log(listaVazia);
        log(listaFixa);
        log(listaGerada);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        var l = [10, 20, 30];

        log(l.length);
        log(l.isEmpty);
        log(l.isNotEmpty);
        log(l.first);
        log(l.last);
        log(l.reversed.toList());
      },
    );
  }

  void runAdicaoInsercao() {
    runSection(
      title: "Adição e Inserção",
      code: adicaoInsercaoCode,
      action: () {
        var l = [10, 20, 30];

        l.add(40);
        l.addAll([50, 60]);
        l.insert(1, 15);
        l.insertAll(2, [16, 17]);

        log(l);
      },
    );
  }

  void runRemocao() {
    runSection(
      title: "Remoção",
      code: remocaoCode,
      action: () {
        var remocoes = [10, 20, 30, 20, 40];

        remocoes.remove(20);
        log(remocoes);

        remocoes.removeAt(0);
        log(remocoes);

        remocoes.removeLast();
        log(remocoes);

        remocoes.removeRange(0, 2);
        log(remocoes);

        remocoes.clear();
        log(remocoes);
      },
    );
  }

  void runBusca() {
    runSection(
      title: "Busca e Verificação",
      code: buscaCode,
      action: () {
        var nums = [10, 20, 30, 20];

        log(nums.contains(20));
        log(nums.indexOf(20));
        log(nums.lastIndexOf(20));
        log(nums.elementAt(2));
      },
    );
  }

  void runIteracao() {
    runSection(
      title: "Iteração",
      code: iteracaoCode,
      action: () {
        var nums = [10, 20, 30, 20];

        for (var item in nums) {
          log(item);
        }

        nums.forEach(log);
      },
    );
  }

  void runTransformacao() {
    runSection(
      title: "Transformação",
      code: transformacaoCode,
      action: () {
        var nums = [10, 20, 30, 20];

        var dobrados = nums.map((n) => n * 2).toList();
        var pares = nums.where((n) => n.isEven).toList();
        var primeiroGrande = nums.firstWhere((n) => n > 15, orElse: () => -1);
        var soma = nums.reduce((a, b) => a + b);
        var acumulado = nums.fold(100, (a, b) => a + b);

        log(dobrados);
        log(pares);
        log(primeiroGrande);
        log(soma);
        log(acumulado);
      },
    );
  }

  void runOrdenacao() {
    runSection(
      title: "Ordenação",
      code: ordenacaoCode,
      action: () {
        var ordenacao = [30, 10, 20, 5];

        ordenacao.sort();
        log(ordenacao);

        ordenacao.sort((a, b) => b.compareTo(a));
        log(ordenacao);
      },
    );
  }

  void runCopiaPartes() {
    runSection(
      title: "Cópia e Partes",
      code: copiaPartesCode,
      action: () {
        var nums = [10, 20, 30, 20];

        var copia = List.from(nums);
        var imutavel = List.unmodifiable(nums);
        var sub = nums.sublist(1, 3);

        log(copia);
        log(imutavel);
        log(sub);
      },
    );
  }

  void runIntervalo() {
    runSection(
      title: "Intervalo",
      code: intervaloCode,
      action: () {
        var intervalo = [1, 2, 3, 4];

        intervalo.fillRange(1, 3, 99);
        log(intervalo);

        intervalo.replaceRange(0, 2, [7, 8]);
        log(intervalo);
      },
    );
  }

  void runSpread() {
    runSection(
      title: "Spread",
      code: spreadCode,
      action: () {
        var a = [1, 2];
        var b = [0, ...a, 3];
        log(b);

        List<int>? c;
        var d = [0, ...?c, 3];
        log(d);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    var lista1 = [1, 2, 3];
    List<String> lista2 = ['a', 'b'];
    var listaVazia = <int>[];
    var listaFixa = List.filled(3, 0);
    var listaGerada = List.generate(5, (i) => i * 2);

    log(lista1);
    log(lista2);
    log(listaVazia);
    log(listaFixa);
    log(listaGerada);

    var l = [10, 20, 30];
    log(l.length);
    log(l.first);
    log(l.last);

    l.add(40);
    l.insert(1, 15);
    log(l);

    var nums = [10, 20, 30, 20];
    log(nums.contains(20));
    log(nums.indexOf(20));

    var dobrados = nums.map((n) => n * 2).toList();
    log(dobrados);

    var ordenacao = [30, 10, 20, 5];
    ordenacao.sort();
    log(ordenacao);

    var a = [1, 2];
    var b = [0, ...a, 3];
    log(b);
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
      appBar: AppBar(title: const Text("List")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo List em Dart",
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
              description: "Criar listas tipadas, vazias, fixas e geradas.",
              onRun: runCriacao,
            ),
            buildSection(
              title: "Propriedades",
              description: "Acessar tamanho, primeiro, último e reverso.",
              onRun: runPropriedades,
            ),
            buildSection(
              title: "Adição e Inserção",
              description:
                  "Adicionar itens no final ou em posições específicas.",
              onRun: runAdicaoInsercao,
            ),
            buildSection(
              title: "Remoção",
              description: "Remover itens, intervalos e limpar a lista.",
              onRun: runRemocao,
            ),
            buildSection(
              title: "Busca e Verificação",
              description: "Buscar elementos e verificar se existem.",
              onRun: runBusca,
            ),
            buildSection(
              title: "Iteração",
              description: "Percorrer a lista com for-in e forEach.",
              onRun: runIteracao,
            ),
            buildSection(
              title: "Transformação",
              description: "Usar map, where, firstWhere, reduce e fold.",
              onRun: runTransformacao,
            ),
            buildSection(
              title: "Ordenação",
              description: "Ordenar em ordem crescente e decrescente.",
              onRun: runOrdenacao,
            ),
            buildSection(
              title: "Cópia e Partes",
              description: "Copiar listas e extrair sublistas.",
              onRun: runCopiaPartes,
            ),
            buildSection(
              title: "Intervalo",
              description: "Preencher e substituir intervalos da lista.",
              onRun: runIntervalo,
            ),
            buildSection(
              title: "Spread",
              description: "Usar spread e null-aware spread.",
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
