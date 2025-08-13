// lib/data/topics/oop/constructors.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent constructorsTopic = TopicContent(
  title: 'Construtores',
  code:
      '''// Construtores são métodos especiais usados para criar e inicializar objetos
// (instâncias) de uma classe.

class Pessoa {
  String nome;
  int idade;
  String? _cpf; // Atributo privado

  // 1. Construtor Padrão (Sintaxe abreviada)
  // `this.nome` e `this.idade` são atalhos para atribuir os parâmetros
  // diretamente aos atributos da classe.
  Pessoa(this.nome, this.idade);

  // 2. Construtor Nomeado
  // Útil quando você precisa de múltiplas formas de construir um objeto
  // ou para tornar a intenção do construtor mais clara.
  Pessoa.comCPF(this.nome, this.idade, String cpf) : _cpf = cpf;

  // 3. Construtor com Parâmetros Nomeados e Opcionais
  // {required this.nome, this.idade = 0}
  // `required` torna o parâmetro obrigatório mesmo sendo nomeado.
  // `= 0` define um valor padrão se `idade` não for fornecido.
  Pessoa.criar({required this.nome, this.idade = 0, String? cpf}) : _cpf = cpf;

  // 4. Construtor de Fábrica (factory constructor)
  // Não cria diretamente uma nova instância.
  // Pode retornar uma instância existente, um subtipo ou uma instância calculada.
  // Útil para lógica de cache ou validação antes da criação.
  factory Pessoa.anonimo() {
    return Pessoa('Visitante', 0); // Retorna uma instância de Pessoa
  }

  // 5. Construtor Const (Constant constructor)
  // Usado para criar instâncias imutáveis (const).
  // Todos os campos da classe devem ser final.
  const Pessoa.constante(this.nome, this.idade);

  void apresentar() {
    String infoCpf = (_cpf != null) ? ' (CPF: \$_cpf)' : '';
    print('Olá, meu nome é \$nome e tenho \$idade anos\$infoCpf.');
  }
}

void main() {
  print('--- Construtor Padrão ---');
  var p1 = Pessoa('Alice', 30);
  p1.apresentar();

  print('\\n--- Construtor Nomeado (comCPF) ---');
  var p2 = Pessoa.comCPF('Bob', 25, '123.456.789-00');
  p2.apresentar();

  print('\\n--- Construtor com Parâmetros Nomeados (criar) ---');
  var p3 = Pessoa.criar(nome: 'Carlos', idade: 40);
  p3.apresentar();
  var p4 = Pessoa.criar(nome: 'Diana'); // Idade usa valor padrão (0)
  p4.apresentar();
  var p5 = Pessoa.criar(nome: 'Eva', cpf: '987.654.321-99');
  p5.apresentar();


  print('\\n--- Construtor de Fábrica (anonimo) ---');
  var p6 = Pessoa.anonimo();
  p6.apresentar();

  print('\\n--- Construtor Const ---');
  // Instâncias criadas com 'const' são canônicas (se os valores são iguais, é a mesma instância)
  const Pessoa p7 = Pessoa.constante('Fernando', 50);
  const Pessoa p8 = Pessoa.constante('Fernando', 50);
  print('P7 e P8 são a mesma instância? \${identical(p7, p8)}'); // Saída: true
  p7.apresentar();

  // Uma instância criada sem 'const' (mesmo que a classe tenha construtor const)
  // não é canônica e cria uma nova instância.
  var p9 = Pessoa.constante('Fernando', 50);
  print('P7 e P9 são a mesma instância? \${identical(p7, p9)}'); // Saída: false
}''',
  output: '''--- Construtor Padrão ---
Olá, meu nome é Alice e tenho 30 anos.

--- Construtor Nomeado (comCPF) ---
Olá, meu nome é Bob e tenho 25 anos (CPF: 123.456.789-00).

--- Construtor com Parâmetros Nomeados (criar) ---
Olá, meu nome é Carlos e tenho 40 anos.
Olá, meu nome é Diana e tenho 0 anos.
Olá, meu nome é Eva e tenho 0 anos (CPF: 987.654.321-99).

--- Construtor de Fábrica (anonimo) ---
Olá, meu nome é Visitante e tenho 0 anos.

--- Construtor Const ---
P7 e P8 são a mesma instância? true
Olá, meu nome é Fernando e tenho 50 anos.
P7 e P9 são a mesma instância? false''',
  description:
      'Construtores em Dart são métodos especiais usados para criar e inicializar objetos de uma classe. Existem vários tipos: construtor padrão (posicional ou nomeado), construtores nomeados para criar instâncias de formas diferentes, construtores de fábrica (`factory`) para lógica de criação complexa (como cache ou subclasses), e construtores `const` para criar instâncias imutáveis e otimizadas em tempo de compilação.',
);
