// lib/data/topics/fundamental/errors.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent errorsTopic = TopicContent(
  title: 'Erros e Exceções',
  code: '''// Função que pode lançar uma exceção
double dividir(double a, double b) {
  if (b == 0) {
    // Lança uma exceção personalizada
    throw Exception('Não é possível dividir por zero!');
  }
  return a / b;
}

// Função que lança um formato de exceção específico
void processarNumero(String texto) {
  try {
    int numero = int.parse(texto); // Tenta converter string para int
    print('Número processado: \$numero');
  } on FormatException {
    // Captura apenas FormatException
    print('Erro: Formato de número inválido. Não foi possível converter  para um número.');
  } catch (e) {
    // Captura qualquer outra exceção não tratada especificamente
    print('Ocorreu um erro inesperado: \$e');
  } finally {
    // O bloco finally sempre é executado, independentemente de erro
    print('Execução do bloco processarNumero finalizada.');
  }
}

void main() {
  print('--- Tratamento de Exceções ---');

  // Exemplo 1: Tratando exceção de divisão por zero
  try {
    double resultado = dividir(10, 2);
    print('Resultado da divisão: \$resultado');

    resultado = dividir(10, 0); // Isso lançará uma exceção
    print('Este print não será executado.'); // Não alcançável
  } on Exception catch (e) { // Captura a exceção específica do tipo Exception
    print('Erro na divisão: \${e.toString()}');
  } catch (e, s) { // Captura qualquer outra exceção e a pilha de chamadas
    print('Um erro genérico ocorreu: \$e');
    print('Stack trace: \$s'); // Stack trace é útil para depuração
  } finally {
    print('Bloco try-catch da divisão finalizado.');
  }

  print('\\n--- Processando Números ---');
  processarNumero('123');
  processarNumero('abc');
  processarNumero('45.6'); // int.parse falha aqui também, pode gerar FormatException
}''',
  output: '''--- Tratamento de Exceções ---
Resultado da divisão: 5.0
Erro na divisão: Exception: Não é possível dividir por zero!
Bloco try-catch da divisão finalizado.

--- Processando Números ---
Número processado: 123
Execução do bloco processarNumero finalizada.
Erro: Formato de número inválido. Não foi possível converter "abc" para um número.
Execução do bloco processarNumero finalizada.
Erro: Formato de número inválido. Não foi possível converter "45.6" para um número.
Execução do bloco processarNumero finalizada.''',
  description:
      'Em Dart, erros e exceções são usados para indicar condições anormais ou inesperadas durante a execução de um programa. `try-on-catch-finally` é a estrutura usada para capturar e lidar com exceções de forma controlada. `try` encapsula o código que pode lançar uma exceção, `on` captura exceções de um tipo específico, `catch` captura qualquer exceção e o stack trace, e `finally` garante que um bloco de código seja executado independentemente de ter ocorrido uma exceção.',
);
