// lib/data/topics/fundamental/functions.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent functionsTopic = TopicContent(
  title: 'Funções',
  code: '''// 1. Função simples sem parâmetros e sem retorno
void saudar() {
  print('Olá, bem-vindo(a) ao Dart!');
}

// 2. Função com parâmetros e sem retorno
void imprimirMensagem(String mensagem) {
  print('Mensagem: \$mensagem');
}

// 3. Função com parâmetros e com retorno
int somar(int a, int b) {
  return a + b;
}

// 4. Função com expressão de corpo curta (arrow function)
// Ideal para funções de uma única linha.
double multiplicar(double a, double b) => a * b;

// 5. Função com parâmetros opcionais posicionais []
// Os parâmetros dentro de [] são opcionais e posicionais.
// Se não forem passados, terão o valor null por padrão.
void exibirDetalhes(String nome, [int? idade, String? cidade]) {
  print('Nome: \$nome');
  if (idade != null) print('Idade: \$idade');
  if (cidade != null) print('Cidade: \$cidade');
}

// 6. Função com parâmetros opcionais nomeados {}
// Mais flexíveis, a ordem não importa. Podem ser `required` ou ter um valor padrão.
void configurarPerfil({required String email, String? telefone, bool ativo = true}) {
  print('Email: \$email');
  if (telefone != null) print('Telefone: \$telefone');
  print('Ativo: \$ativo');
}

// 7. Função como parâmetro (Higher-Order Functions)
void executarOperacao(int x, int y, Function(int, int) operacao) {
  print('Resultado da operação: \${operacao(x, y)}');
}

void main() {
  print('--- Função Simples ---');
  saudar();

  print('\\n--- Função com Parâmetro ---');
  imprimirMensagem('Este é um exemplo de função.');

  print('\\n--- Função com Retorno ---');
  int resultadoSoma = somar(5, 3);
  print('A soma de 5 e 3 é: \$resultadoSoma');

  print('\\n--- Função com Arrow Function ---');
  double resultadoMultiplicacao = multiplicar(2.5, 4.0);
  print('A multiplicação de 2.5 e 4.0 é: \$resultadoMultiplicacao');

  print('\\n--- Parâmetros Opcionais Posicionais ---');
  exibirDetalhes('João');
  exibirDetalhes('Maria', 25);
  exibirDetalhes('Pedro', 30, 'Rio de Janeiro');

  print('\\n--- Parâmetros Opcionais Nomeados ---');
  configurarPerfil(email: 'ana@email.com');
  configurarPerfil(email: 'bob@email.com', telefone: '987654321', ativo: false);

  print('\\n--- Função como Parâmetro (Higher-Order) ---');
  executarOperacao(10, 5, somar); // Passando a função somar
  executarOperacao(20, 4, (a, b) => a ~/ b); // Passando uma função anônima
}''',
  output: '''--- Função Simples ---
Olá, bem-vindo(a) ao Dart!

--- Função com Parâmetro ---
Mensagem: Este é um exemplo de função.

--- Função com Retorno ---
A soma de 5 e 3 é: 8

--- Função com Arrow Function ---
A multiplicação de 2.5 e 4.0 é: 10.0

--- Parâmetros Opcionais Posicionais ---
Nome: João
Nome: Maria
Idade: 25
Nome: Pedro
Idade: 30
Cidade: Rio de Janeiro

--- Parâmetros Opcionais Nomeados ---
Email: ana@email.com
Ativo: true
Email: bob@email.com
Telefone: 987654321
Ativo: false

--- Função como Parâmetro (Higher-Order) ---
Resultado da operação: 15
Resultado da operação: 5''',
  description:
      'Funções em Dart são blocos de código que realizam uma tarefa específica e podem ser reutilizados. Elas podem ter parâmetros (posicionais, nomeados, opcionais) e retornar valores. Dart também suporta funções de corpo curto (`=>`) e "Higher-Order Functions", onde funções podem ser passadas como argumentos ou retornadas por outras funções.',
);
