// lib/data/topics/fundamental/loop_structures.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent loopStructuresTopic = TopicContent(
  title: 'Estruturas de Repetição (Loops)',
  code: '''// Loops permitem que você execute um bloco de código repetidamente.

void main() {
  print('--- Loop for ---');
  // O loop 'for' é usado quando o número de iterações é conhecido.
  // Sintaxe: for (inicialização; condição; incremento) { ... }
  for (int i = 0; i < 3; i++) {
    print('Contador for: \$i');
  }

  print('\\n--- Loop while ---');
  // O loop 'while' executa um bloco de código enquanto uma condição é verdadeira.
  // A condição é verificada ANTES de cada execução do bloco.
  int contadorWhile = 0;
  while (contadorWhile < 3) {
    print('Contador while: \$contadorWhile');
    contadorWhile++; // Não esqueça de incrementar para evitar loop infinito!
  }

  print('\\n--- Loop do-while ---');
  // O loop 'do-while' executa o bloco de código PELO MENOS UMA VEZ,
  // e depois verifica a condição.
  int contadorDoWhile = 0;
  do {
    print('Contador do-while: \$contadorDoWhile');
    contadorDoWhile++;
  } while (contadorDoWhile < 3);

  print('\\n--- Loop for-in (Iterando sobre coleções) ---');
  // O loop 'for-in' é usado para iterar sobre elementos de coleções (List, Set).
  List<String> frutas = ['Maçã', 'Banana', 'Cereja'];
  for (String fruta in frutas) {
    print('Eu gosto de: \$fruta');
  }

  // Com break e continue
  print('\\n--- Usando break e continue em loops ---');
  for (int i = 0; i < 5; i++) {
    if (i == 2) {
      print('  -> Pulando o número 2 com continue...');
      continue; // Pula a iteração atual, vai para a próxima (i=3)
    }
    if (i == 4) {
      print('  -> Saindo do loop no número 4 com break...');
      break; // Sai do loop completamente
    }
    print('  Número: \$i');
  }
}''',
  output: '''--- Loop for ---
Contador for: 0
Contador for: 1
Contador for: 2

--- Loop while ---
Contador while: 0
Contador while: 1
Contador while: 2

--- Loop do-while ---
Contador do-while: 0
Contador do-while: 1
Contador do-while: 2

--- Loop for-in (Iterando sobre coleções) ---
Eu gosto de: Maçã
Eu gosto de: Banana
Eu gosto de: Cereja

--- Usando break e continue em loops ---
  Número: 0
  Número: 1
  -> Pulando o número 2 com continue...
  Número: 3
  -> Saindo do loop no número 4 com break...''',
  description:
      'Estruturas de repetição, ou loops, permitem que um bloco de código seja executado múltiplas vezes. O Dart oferece o loop `for` para um número definido de iterações, `while` para repetição baseada em uma condição, `do-while` que garante pelo menos uma execução, e `for-in` para iterar sobre coleções. As palavras-chave `break` e `continue` são usadas para controlar o fluxo dentro dos loops.',
);
