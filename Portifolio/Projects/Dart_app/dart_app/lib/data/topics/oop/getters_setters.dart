// lib/data/topics/oop/getters_setters.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent gettersSettersTopic = TopicContent(
  title: 'Getters e Setters',
  code: '''// Getters e Setters são métodos especiais que permitem controlar
// o acesso e a modificação das propriedades de uma classe.
// Eles oferecem uma forma de encapsulamento, permitindo adicionar lógica
// antes de retornar ou atribuir um valor.

class Produto {
  String _nome;    // Convenção: prefixo '_' indica um campo privado
  double _preco;
  int _estoque;

  Produto(this._nome, this._preco, this._estoque);

  // 1. Getter Explícito (customizado)
  // Permite adicionar lógica antes de retornar o valor de _nome.
  String get nome {
    return _nome.toUpperCase(); // Retorna o nome em maiúsculas
  }

  // 2. Setter Explícito (customizado)
  // Permite adicionar lógica de validação antes de atribuir um valor a _nome.
  set nome(String novoNome) {
    if (novoNome.isNotEmpty) {
      _nome = novoNome;
    } else {
      print('Erro: O nome do produto não pode ser vazio.');
    }
  }

  // 3. Getter Computado (calculado)
  // Calcula e retorna um valor com base em outros atributos,
  // sem ter um campo de armazenamento direto.
  double get precoComDesconto {
    return _preco * 0.9; // 10% de desconto
  }

  // 4. Setter com Validação para _preco
  set preco(double novoPreco) {
    if (novoPreco > 0) {
      _preco = novoPreco;
    } else {
      print('Erro: O preço deve ser maior que zero.');
    }
  }

  // 5. Getter e Setter implícitos (automáticos)
  // Se você apenas declara um campo público (sem '_'), Dart cria
  // getters e setters implícitos para ele automaticamente.
  // Para _estoque, vamos usar o padrão para demonstração.
  int get estoque => _estoque; // Podemos usar um getter explícito simples para consistência
  set estoque(int novoEstoque) {
    if (novoEstoque >= 0) {
      _estoque = novoEstoque;
    } else {
      print('Erro: O estoque não pode ser negativo.');
    }
  }

  void exibirDetalhes() {
    print('Produto: \$nome (Preço Original: \$_preco, Preço c/ Desconto: \$precoComDesconto, Estoque: \$_estoque)');
  }
}

void main() {
  var p = Produto('Laptop', 1500.0, 10);
  p.exibirDetalhes();

  print('\\n--- Usando Getters ---');
  print('Nome do produto (getter): \${p.nome}'); // Chama o getter 'nome'
  print('Preço com desconto (getter computado): \${p.precoComDesconto}');

  print('\\n--- Usando Setters ---');
  p.nome = 'Smartphone'; // Chama o setter 'nome'
  p.preco = 800.0;     // Chama o setter 'preco'
  p.estoque = 5;       // Chama o setter 'estoque'
  p.exibirDetalhes();

  print('\\n--- Testando validações do Setter ---');
  p.nome = '';        // Tentativa inválida
  p.preco = -50.0;    // Tentativa inválida
  p.estoque = -1;     // Tentativa inválida
  p.exibirDetalhes(); // Verifique que os valores não mudaram se a validação falhou
}''',
  output:
      '''Produto: LAPTOP (Preço Original: 1500.0, Preço c/ Desconto: \$1350.0, Estoque: 10)

--- Usando Getters ---
Nome do produto (getter): LAPTOP
Preço com desconto (getter computado): 1350.0

--- Usando Setters ---
Produto: SMARTPHONE (Preço Original: 800.0, Preço c/ Desconto: 720.0, Estoque: 5)

--- Testando validações do Setter ---
Erro: O nome do produto não pode ser vazio.
Erro: O preço deve ser maior que zero.
Erro: O estoque não pode ser negativo.
Produto: SMARTPHONE (Preço Original: 800.0, Preço c/ Desconto: 720.0, Estoque: 5)''',
  description:
      'Getters e Setters em Dart são métodos especiais que fornecem controle sobre como os atributos de uma classe são lidos e modificados. Getters (`get`) são usados para obter valores de forma controlada (podendo incluir lógica ou computar um valor). Setters (`set`) são usados para definir valores, permitindo validação ou outras ações antes da atribuição. Eles promovem o encapsulamento e a integridade dos dados da classe.',
);
