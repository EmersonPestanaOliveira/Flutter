// lib/data/topics/fundamental/operators.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent operatorsTopic = TopicContent(
  title: 'Operadores', // Título explícito para exibição
  code: '''void main() {
  int a = 10;
  int b = 3;

  print('--- Operadores Aritméticos ---');
  print('a + b = \${a + b}');       // Soma: 13
  print('a - b = \${a - b}');       // Subtração: 7
  print('a * b = \${a * b}');       // Multiplicação: 30
  print('a / b = \${a / b}');       // Divisão (retorna double): 3.333...
  print('a ~/ b = \${a ~/ b}');     // Divisão inteira (trunca): 3
  print('a % b = \${a % b}');       // Resto da divisão: 1

  print('\\n--- Operadores de Atribuição ---');
  int c = 5;
  print('c inicial: \$c');         // 5
  c += 2; // Equivalente a c = c + 2;
  print('c depois de c += 2: \$c'); // 7
  c -= 3; // Equivalente a c = c - 3;
  print('c depois de c -= 3: \$c'); // 4
  c *= 4; // Equivalente a c = c * 4;
  print('c depois de c *= 4: \$c'); // 16
  c ~/= 2; // Equivalente a c = c ~/ 2;
  print('c depois de c ~/= 2: \$c'); // 8

  print('\\n--- Operadores de Comparação ---');
  print('a > b: \${a > b}');       // true (10 > 3)
  print('a < b: \${a < b}');       // false (10 < 3)
  print('a >= 10: \${a >= 10}');   // true (10 >= 10)
  print('b <= 3: \${b <= 3}');     // true (3 <= 3)
  print('a == 10: \${a == 10}');   // true (10 == 10)
  print('a != b: \${a != b}');     // true (10 != 3)

  print('\\n--- Operadores Lógicos ---');
  bool verdadeiro = true;
  bool falso = false;
  print('verdadeiro && falso: \${verdadeiro && falso}'); // AND: false
  print('verdadeiro || falso: \${verdadeiro || falso}'); // OR: true
  print('!verdadeiro: \${!verdadeiro}');        // NOT: false

  print('\\n--- Operador de Tipo (is) ---');
  var minhaVariavel = 'Dart';
  print('minhaVariavel é String: \${minhaVariavel is String}'); // true
  print('minhaVariavel é int: \${minhaVariavel is int}');     // false

  print('\\n--- Operador Null-aware (??) ---');
  String? nomeNulo;
  String nomePadrao = nomeNulo ?? 'Visitante';
  print('Nome padrão: \$nomePadrao'); // Visitante

  String? nomeNaoNulo = 'Maria';
  String outroNome = nomeNaoNaoNulo ?? 'Convidado';
  print('Outro nome: \$outroNome'); // Maria
}''',
  output: '''--- Operadores Aritméticos ---
a + b = 13
a - b = 7
a * b = 30
a / b = 3.3333333333333335
a ~/ b = 3
a % b = 1

--- Operadores de Atribuição ---
c inicial: 5
c depois de c += 2: 7
c depois de c -= 3: 4
c depois de c *= 4: 16
c depois de c ~/= 2: 8

--- Operadores de Comparação ---
a > b: true
a < b: false
a >= 10: true
b <= 3: true
a == 10: true
a != b: true

--- Operadores Lógicos ---
verdadeiro && falso: false
verdadeiro || falso: true
!verdadeiro: false

--- Operador de Tipo (is) ---
minhaVariavel é String: true
minhaVariavel é int: false

--- Operador Null-aware (??) ---
Nome padrão: Visitante
Outro nome: Maria''',
  description:
      'Operadores são símbolos que instruem o compilador a executar operações matemáticas ou lógicas específicas. Dart possui uma rica variedade de operadores, incluindo aritméticos, de atribuição, de comparação, lógicos, de tipo e null-aware.',
);
