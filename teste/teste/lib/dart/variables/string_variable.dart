import 'package:flutter/material.dart';

class StringVariablePage extends StatefulWidget {
  const StringVariablePage({super.key});

  @override
  State<StringVariablePage> createState() => _StringVariablePageState();
}

class _StringVariablePageState extends State<StringVariablePage> {
  final List<String> console = [];
  String currentCode = '// Selecione uma seção para ver o código aqui';

  void log(Object? value) {
    setState(() {
      console.add(value.toString());
    });
  }

  void section(String title, String code) {
    setState(() {
      currentCode = code;
      console.add('');
      console.add('===== $title =====');
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

  String get declaracaoCode => r'''
// Declaração de strings em formatos diferentes

var s1 = "aspas duplas"; 
// Cria uma string usando aspas duplas

var s2 = 'aspas simples'; 
// Cria uma string usando aspas simples

var s3 = 'interpolação: ${2 + 2}'; 
// Insere o resultado de uma expressão dentro da string

var s4 = r'raw: \n não quebra linha'; 
// Raw string: trata \n como texto literal, sem quebrar linha

print(s1); 
// Exibe o conteúdo de s1 no console

print(s2); 
// Exibe o conteúdo de s2 no console

print(s3); 
// Exibe a string já com a interpolação resolvida

print(s4); 
// Exibe a raw string exatamente como foi escrita
''';

  String get propriedadesCode => r'''
// Propriedades de String

String s = " Dart ";
// String com espaços no começo e no fim

print(s.length);
// Mostra a quantidade de caracteres, incluindo espaços

print(s.isEmpty);
// Retorna true se a string estiver vazia

print(s.isNotEmpty);
// Retorna true se a string não estiver vazia

print(s.codeUnits);
// Mostra os códigos UTF-16 de cada caractere
''';

  String get buscaCode => r'''
// Busca e verificação em strings

var u = "banana";
// String usada nos exemplos de busca

print(u.contains("na"));
// Verifica se "na" existe dentro da string

print(u.startsWith("ba"));
// Verifica se a string começa com "ba"

print(u.endsWith("na"));
// Verifica se a string termina com "na"

print(u.indexOf("na"));
// Retorna a posição da primeira ocorrência de "na"
''';

  String get transformacoesCode => r'''
// Transformações em strings

var a = "  Dart  ";
// String com espaços extras

print(a.toLowerCase());
// Converte todos os caracteres para minúsculo

print(a.toUpperCase());
// Converte todos os caracteres para maiúsculo

print(a.trim());
// Remove espaços do começo e do fim
''';

  String get regexCode => r'''
// Expressões regulares com String

var text = "ID: A12 B34 C56";
// Texto com padrões parecidos com letra + números

var re = RegExp(r'[A-Z]\d+');
// Regex que encontra uma letra maiúscula seguida de um ou mais dígitos

print(re.hasMatch(text));
// Verifica se existe pelo menos uma ocorrência no texto

for (final m in re.allMatches(text)) {
  print(m.group(0));
  // Exibe cada trecho encontrado pela expressão regular
}
''';

  String get conversoesCode => r'''
// Conversões relacionadas a String

print(int.parse("42"));
// Converte texto "42" para número inteiro

print(double.parse("3.14"));
// Converte texto "3.14" para número decimal

print(String.fromCharCode(0x1F680));
// Cria uma string a partir de um código Unicode
''';

  String get allCode => r'''
// Declaração de strings
var s1 = "aspas duplas"; 
// String com aspas duplas

var s2 = 'aspas simples'; 
// String com aspas simples

var s3 = 'interpolação: ${2 + 2}'; 
// Interpolação de expressão dentro da string

var s4 = r'raw: \n não quebra linha'; 
// Raw string, sem interpretar caracteres especiais

print(s1);
print(s2);
print(s3);
print(s4);

// Propriedades
String s = " Dart ";
// String com espaços para testar propriedades

print(s.length);
// Total de caracteres

print(s.isEmpty);
// Verifica se está vazia

print(s.isNotEmpty);
// Verifica se não está vazia

print(s.codeUnits);
// Lista os códigos UTF-16

// Busca
var u = "banana";
// Base para testes de busca

print(u.contains("na"));
// Procura trecho dentro da string

print(u.startsWith("ba"));
// Verifica começo da string

print(u.endsWith("na"));
// Verifica final da string

print(u.indexOf("na"));
// Posição da primeira ocorrência

// Transformações
var a = "  Dart  ";
// String com espaços extras

print(a.toLowerCase());
// Tudo minúsculo

print(a.toUpperCase());
// Tudo maiúsculo

print(a.trim());
// Remove espaços nas pontas

// Regex
var text = "ID: A12 B34 C56";
// Texto de exemplo

var re = RegExp(r'[A-Z]\d+');
// Busca padrões como A12, B34, C56

print(re.hasMatch(text));
// Verifica se encontrou algum padrão

for (final m in re.allMatches(text)) {
  print(m.group(0));
  // Mostra cada resultado encontrado
}

// Conversões
print(int.parse("42"));
// Texto para inteiro

print(double.parse("3.14"));
// Texto para decimal

print(String.fromCharCode(0x1F680));
// Unicode para caractere
''';

  void runDeclaracao() {
    runSection(
      title: "Declaração",
      code: declaracaoCode,
      action: () {
        var s1 = "aspas duplas";
        var s2 = 'aspas simples';
        var s3 = 'interpolação: ${2 + 2}';
        var s4 = r'raw: \n não quebra linha';

        log(s1);
        log(s2);
        log(s3);
        log(s4);
      },
    );
  }

  void runPropriedades() {
    runSection(
      title: "Propriedades",
      code: propriedadesCode,
      action: () {
        String s = " Dart ";
        log(s.length);
        log(s.isEmpty);
        log(s.isNotEmpty);
        log(s.codeUnits);
      },
    );
  }

  void runBusca() {
    runSection(
      title: "Busca",
      code: buscaCode,
      action: () {
        var u = "banana";
        log(u.contains("na"));
        log(u.startsWith("ba"));
        log(u.endsWith("na"));
        log(u.indexOf("na"));
      },
    );
  }

  void runTransformacoes() {
    runSection(
      title: "Transformações",
      code: transformacoesCode,
      action: () {
        var a = "  Dart  ";
        log(a.toLowerCase());
        log(a.toUpperCase());
        log(a.trim());
      },
    );
  }

  void runRegex() {
    runSection(
      title: "Regex",
      code: regexCode,
      action: () {
        var text = "ID: A12 B34 C56";
        var re = RegExp(r'[A-Z]\d+');
        log(re.hasMatch(text));
        for (final m in re.allMatches(text)) {
          log(m.group(0));
        }
      },
    );
  }

  void runConversoes() {
    runSection(
      title: "Conversões",
      code: conversoesCode,
      action: () {
        log(int.parse("42"));
        log(double.parse("3.14"));
        log(String.fromCharCode(0x1F680));
      },
    );
  }

  void runAll() {
    setState(() {
      currentCode = allCode;
      console.clear();
    });

    console.add('===== Executando tudo =====');

    var s1 = "aspas duplas";
    var s2 = 'aspas simples';
    var s3 = 'interpolação: ${2 + 2}';
    var s4 = r'raw: \n não quebra linha';

    log(s1);
    log(s2);
    log(s3);
    log(s4);

    String s = " Dart ";
    log(s.length);
    log(s.isEmpty);
    log(s.isNotEmpty);
    log(s.codeUnits);

    var u = "banana";
    log(u.contains("na"));
    log(u.startsWith("ba"));
    log(u.endsWith("na"));
    log(u.indexOf("na"));

    var a = "  Dart  ";
    log(a.toLowerCase());
    log(a.toUpperCase());
    log(a.trim());

    var text = "ID: A12 B34 C56";
    var re = RegExp(r'[A-Z]\d+');
    log(re.hasMatch(text));
    for (final m in re.allMatches(text)) {
      log(m.group(0));
    }

    log(int.parse("42"));
    log(double.parse("3.14"));
    log(String.fromCharCode(0x1F680));
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
            const SizedBox(height: 12),
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
      appBar: AppBar(title: const Text("String")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Exemplos de String em Dart",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: runAll,
                  child: const Text("Executar todos"),
                ),
                const SizedBox(width: 8),
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
                  "Criação de strings com aspas simples, duplas, raw string e interpolação.",
              onRun: runDeclaracao,
            ),
            buildSection(
              title: "Propriedades",
              description:
                  "Mostra tamanho, verificação de vazio e códigos internos dos caracteres.",
              onRun: runPropriedades,
            ),
            buildSection(
              title: "Busca",
              description:
                  "Procura trechos e verifica começo, fim e posição dentro da string.",
              onRun: runBusca,
            ),
            buildSection(
              title: "Transformações",
              description: "Converte letras e remove espaços extras.",
              onRun: runTransformacoes,
            ),
            buildSection(
              title: "Regex",
              description: "Encontra padrões usando expressões regulares.",
              onRun: runRegex,
            ),
            buildSection(
              title: "Conversões",
              description: "Transforma texto em número e Unicode em caractere.",
              onRun: runConversoes,
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
