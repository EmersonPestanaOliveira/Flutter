import 'package:flutter/material.dart';

class MapVariablePage extends StatefulWidget {
  const MapVariablePage({super.key});

  @override
  State<MapVariablePage> createState() => _MapVariablePageState();
}

class _MapVariablePageState extends State<MapVariablePage> {
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
// Criação de mapas

var mapa1 = {'a': 1, 'b': 2};
// Map com inferência de tipo

Map<int, String> mapa2 = {1: 'um', 2: 'dois'};
// Map tipado com chave int e valor String

var vazio1 = <String, int>{};
// Map vazio tipado

var vazio2 = Map<String, int>();
// Outra forma de criar um Map vazio

var imutavel = Map.unmodifiable({'x': 10, 'y': 20});
// Cria um Map que não pode ser alterado

print(mapa1);
print(mapa2);
print(vazio1);
print(vazio2);
print(imutavel);
''';

  String get propriedadesCode => r'''
// Propriedades do Map

var m = {'a': 1, 'b': 2, 'c': 3};
// Map usado para demonstrar propriedades

print(m.length);
// Quantidade de pares chave/valor

print(m.isEmpty);
// Verifica se está vazio

print(m.isNotEmpty);
// Verifica se não está vazio

print(m.keys);
// Retorna todas as chaves

print(m.values);
// Retorna todos os valores
''';

  String get acessoModificacaoCode => r'''
// Acesso e modificação

var m = {'a': 1, 'b': 2, 'c': 3};

print(m['a']);
// Acessa o valor da chave 'a'

print(m['z']);
// Retorna null se a chave não existir

m['d'] = 4;
// Adiciona uma nova chave

m['a'] = 10;
// Atualiza o valor da chave 'a'

print(m);
''';

  String get adicaoCode => r'''
// Adição de itens

var m = {'a': 1, 'b': 2, 'c': 3};

m.addAll({'e': 5, 'f': 6});
// Adiciona vários pares ao Map

m.putIfAbsent('g', () => 7);
// Adiciona a chave 'g' apenas se ela não existir

m.putIfAbsent('a', () => 999);
// Não altera porque 'a' já existe

print(m);
''';

  String get remocaoCode => r'''
// Remoção de itens

var m = {'a': 1, 'b': 2, 'c': 3, 'e': 5, 'f': 6};

m.remove('b');
// Remove a chave 'b'

print(m);

m.removeWhere((chave, valor) => valor > 5);
// Remove entradas cujo valor seja maior que 5

print(m);

var limpar = {'x': 1, 'y': 2};
limpar.clear();
// Remove todos os itens

print(limpar);
''';

  String get verificacaoCode => r'''
// Verificação e busca

var map2 = {'a': 1, 'b': 2};

print(map2.containsKey('a'));
// Verifica se existe a chave 'a'

print(map2.containsValue(2));
// Verifica se existe o valor 2
''';

  String get iteracaoCode => r'''
// Iteração

var map2 = {'a': 1, 'b': 2};

for (var chave in map2.keys) {
  print('$chave: ${map2[chave]}');
}
// Percorre as chaves e acessa seus valores

map2.forEach((k, v) => print('$k -> $v'));
// Percorre chave e valor com forEach
''';

  String get transformacaoCode => r'''
// Transformação

var map2 = {'a': 1, 'b': 2};

var dobrados = map2.map((k, v) => MapEntry(k, v * 2));
// Cria um novo Map com valores dobrados

var filtrado = Map.fromEntries(
  map2.entries.where((e) => e.value > 1),
);
// Cria um novo Map contendo apenas valores maiores que 1

print(dobrados);
print(filtrado);
''';

  String get conversoesCode => r'''
// Conversões

var map2 = {'a': 1, 'b': 2};

var listaChaves = map2.keys.toList();
// Converte as chaves para List

var listaValores = map2.values.toList();
// Converte os valores para List

var copia = Map.from(map2);
// Cria uma cópia do Map

print(listaChaves);
print(listaValores);
print(copia);
''';

  String get spreadCode => r'''
// Spread e null-aware spread

Map<String, int>? opcional;
// Map nulo

var combinado = {'x': 1, ...?opcional, 'y': 2};
// Só espalha o conteúdo se o Map não for nulo

print(combinado);
''';

  String get allCode => r'''
var mapa1 = {'a': 1, 'b': 2};
Map<int, String> mapa2 = {1: 'um', 2: 'dois'};
var vazio1 = <String, int>{};
var vazio2 = Map<String, int>();
var imutavel = Map.unmodifiable({'x': 10, 'y': 20});

print(mapa1);
print(mapa2);
print(vazio1);
print(vazio2);
print(imutavel);

var m = {'a': 1, 'b': 2, 'c': 3};
print(m.length);
print(m.keys);
print(m.values);

print(m['a']);
m['d'] = 4;
print(m);

var map2 = {'a': 1, 'b': 2};
print(map2.containsKey('a'));

var dobrados = map2.map((k, v) => MapEntry(k, v * 2));
print(dobrados);

var listaChaves = map2.keys.toList();
print(listaChaves);

Map<String, int>? opcional;
var combinado = {'x': 1, ...?opcional, 'y': 2};
print(combinado);
''';

  void runCriacao() {
    runSection(
      title: "Criação",
      code: criacaoCode,
      action: () {
        var mapa1 = {'a': 1, 'b': 2};
        Map<int, String> mapa2 = {1: 'um', 2: 'dois'};
        var vazio1 = <String, int>{};
        var vazio2 = Map<String, int>();
        var imutavel = Map.unmodifiable({'x': 10, 'y': 20});

        log(mapa1);
        log(mapa2);
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
        var m = {'a': 1, 'b': 2, 'c': 3};

        log(m.length);
        log(m.isEmpty);
        log(m.isNotEmpty);
        log(m.keys.toList());
        log(m.values.toList());
      },
    );
  }

  void runAcessoModificacao() {
    runSection(
      title: "Acesso e Modificação",
      code: acessoModificacaoCode,
      action: () {
        var m = {'a': 1, 'b': 2, 'c': 3};

        log(m['a']);
        log(m['z']);

        m['d'] = 4;
        m['a'] = 10;

        log(m);
      },
    );
  }

  void runAdicao() {
    runSection(
      title: "Adição",
      code: adicaoCode,
      action: () {
        var m = {'a': 1, 'b': 2, 'c': 3};

        m.addAll({'e': 5, 'f': 6});
        m.putIfAbsent('g', () => 7);
        m.putIfAbsent('a', () => 999);

        log(m);
      },
    );
  }

  void runRemocao() {
    runSection(
      title: "Remoção",
      code: remocaoCode,
      action: () {
        var m = {'a': 1, 'b': 2, 'c': 3, 'e': 5, 'f': 6};

        m.remove('b');
        log(m);

        m.removeWhere((chave, valor) => valor > 5);
        log(m);

        var limpar = {'x': 1, 'y': 2};
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
        var map2 = {'a': 1, 'b': 2};

        log(map2.containsKey('a'));
        log(map2.containsValue(2));
      },
    );
  }

  void runIteracao() {
    runSection(
      title: "Iteração",
      code: iteracaoCode,
      action: () {
        var map2 = {'a': 1, 'b': 2};

        for (var chave in map2.keys) {
          log('$chave: ${map2[chave]}');
        }

        map2.forEach((k, v) => log('$k -> $v'));
      },
    );
  }

  void runTransformacao() {
    runSection(
      title: "Transformação",
      code: transformacaoCode,
      action: () {
        var map2 = {'a': 1, 'b': 2};

        var dobrados = map2.map((k, v) => MapEntry(k, v * 2));
        var filtrado = Map.fromEntries(map2.entries.where((e) => e.value > 1));

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
        var map2 = {'a': 1, 'b': 2};

        var listaChaves = map2.keys.toList();
        var listaValores = map2.values.toList();
        var copia = Map.from(map2);

        log(listaChaves);
        log(listaValores);
        log(copia);
      },
    );
  }

  void runSpread() {
    runSection(
      title: "Spread",
      code: spreadCode,
      action: () {
        Map<String, int>? opcional;
        var combinado = {'x': 1, ...?opcional, 'y': 2};

        log(combinado);
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add("===== Executando tudo =====");

    var mapa1 = {'a': 1, 'b': 2};
    Map<int, String> mapa2 = {1: 'um', 2: 'dois'};
    var vazio1 = <String, int>{};
    var vazio2 = Map<String, int>();
    var imutavel = Map.unmodifiable({'x': 10, 'y': 20});

    log(mapa1);
    log(mapa2);
    log(vazio1);
    log(vazio2);
    log(imutavel);

    var m = {'a': 1, 'b': 2, 'c': 3};
    log(m.length);
    log(m.keys.toList());
    log(m.values.toList());

    log(m['a']);
    m['d'] = 4;
    log(m);

    var map2 = {'a': 1, 'b': 2};
    log(map2.containsKey('a'));

    var dobrados = map2.map((k, v) => MapEntry(k, v * 2));
    log(dobrados);

    var listaChaves = map2.keys.toList();
    log(listaChaves);

    Map<String, int>? opcional;
    var combinado = {'x': 1, ...?opcional, 'y': 2};
    log(combinado);
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
      appBar: AppBar(title: const Text("Map")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tipo Map em Dart",
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
              description: "Criar Maps tipados, vazios e imutáveis.",
              onRun: runCriacao,
            ),
            buildSection(
              title: "Propriedades",
              description: "Acessar tamanho, chaves e valores.",
              onRun: runPropriedades,
            ),
            buildSection(
              title: "Acesso e Modificação",
              description: "Ler, adicionar e atualizar valores por chave.",
              onRun: runAcessoModificacao,
            ),
            buildSection(
              title: "Adição",
              description: "Adicionar vários itens e usar putIfAbsent.",
              onRun: runAdicao,
            ),
            buildSection(
              title: "Remoção",
              description:
                  "Remover entradas específicas, por condição e limpar.",
              onRun: runRemocao,
            ),
            buildSection(
              title: "Verificação e Busca",
              description: "Verificar existência de chaves e valores.",
              onRun: runVerificacao,
            ),
            buildSection(
              title: "Iteração",
              description: "Percorrer chaves e pares chave/valor.",
              onRun: runIteracao,
            ),
            buildSection(
              title: "Transformação",
              description: "Transformar valores e filtrar entradas.",
              onRun: runTransformacao,
            ),
            buildSection(
              title: "Conversões",
              description: "Converter chaves, valores e copiar mapas.",
              onRun: runConversoes,
            ),
            buildSection(
              title: "Spread",
              description: "Combinar mapas com spread e null-aware spread.",
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
