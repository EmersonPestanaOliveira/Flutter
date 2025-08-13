// lib/data/topics/advanced/generics.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent genericsTopic = TopicContent(
  title: 'Generics (Tipos Genéricos)', // Título explícito para exibição
  code: '''// Exemplo 1: Coleções Genéricas (List<T>, Map<K, V>)
void exemploColecoesGenericas() {
  // Uma lista de inteiros (garante que só aceita int)
  List<int> numeros = [1, 2, 3, 4, 5];
  print('Lista de números: \$numeros');
  // numeros.add('seis'); // Erro em tempo de compilação!

  // Um mapa com chaves String e valores dynamic
  Map<String, dynamic> dadosUsuario = {
    'nome': 'Carlos',
    'idade': 40,
    'ativo': true,
  };
  print('Dados do usuário: \$dadosUsuario');

  // Set de Strings
  Set<String> frutas = {'Maçã', 'Banana', 'Laranja'};
  print('Set de frutas: \$frutas');
}

// Exemplo 2: Funções Genéricas
// Uma função que pode operar em uma lista de qualquer tipo
T pegarPrimeiroElemento<T>(List<T> lista) {
  // Garantir que a lista não está vazia para evitar erro de índice
  if (lista.isEmpty) {
    throw ArgumentError('A lista não pode estar vazia.');
  }
  return lista[0];
}

void exemploFuncoesGenericas() {
  List<String> nomes = ['Ana', 'Bruno', 'Clara'];
  String primeiroNome = pegarPrimeiroElemento(nomes);
  print('Primeiro nome: \$primeiroNome');

  List<double> precos = [19.99, 5.50, 100.00];
  double primeiroPreco = pegarPrimeiroElemento(precos);
  print('Primeiro preço: \$primeiroPreco');
}

// Exemplo 3: Classes Genéricas
// Uma classe que pode armazenar um valor de qualquer tipo
class Caixa<T> {
  T conteudo;

  Caixa(this.conteudo);

  void mostrarTipo() {
    print('Conteúdo da caixa é do tipo: \${conteudo.runtimeType}');
  }
}

void exemploClassesGenericas() {
  Caixa<int> caixaDeNumero = Caixa(123);
  print('Conteúdo da caixa de número: \${caixaDeNumero.conteudo}');
  caixaDeNumero.mostrarTipo();

  Caixa<String> caixaDeTexto = Caixa('Olá, Dart!');
  print('Conteúdo da caixa de texto: \${caixaDeTexto.conteudo}');
  caixaDeTexto.mostrarTipo();
}


void main() {
  print('--- Coleções Genéricas ---');
  exemploColecoesGenericas();

  print('\\n--- Funções Genéricas ---');
  exemploFuncoesGenericas();

  print('\\n--- Classes Genéricas ---');
  exemploClassesGenericas();
}''',
  output: '''--- Coleções Genéricas ---
Lista de números: [1, 2, 3, 4, 5]
Dados do usuário: {nome: Carlos, idade: 40, ativo: true}
Set de frutas: {Maçã, Banana, Laranja}

--- Funções Genéricas ---
Primeiro nome: Ana
Primeiro preço: 19.99

--- Classes Genéricas ---
Conteúdo da caixa de número: 123
Conteúdo da caixa é do tipo: int
Conteúdo da caixa de texto: Olá, Dart!
Conteúdo da caixa é do tipo: String''',
  description:
      '**Generics** (ou tipos genéricos) em Dart permitem que você escreva código que pode operar com diferentes tipos de dados, mantendo a segurança de tipo em tempo de compilação. Isso significa que você pode criar classes, funções e interfaces que trabalham com "um tipo genérico" (representado por `<T>`, `<K>`, `<V>`, etc.) e o tipo real é especificado quando o código é usado. Isso aumenta a reutilização do código, a flexibilidade e ajuda a prevenir erros de tipo em tempo de execução.',
);
