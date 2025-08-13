// lib/data/topics/oop/super_keyword.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent superKeywordTopic = TopicContent(
  title: 'Palavra-chave super', // Título explícito para exibição
  code: '''// Palavra-chave `super` em Dart
// A palavra-chave `super` é usada em subclasses para se referir à superclasse (classe pai).
// Ela é principalmente utilizada em duas situações:
// 1. Para chamar o construtor da superclasse.
// 2. Para acessar métodos ou atributos da superclasse que foram sobrescritos na subclasse.

// Superclasse (Classe Pai)
class Animal {
  String nome;
  String especie;

  // Construtor da superclasse
  Animal(this.nome, this.especie) {
    print('Construtor de Animal chamado para \$nome (\$especie).');
  }

  // Método da superclasse
  void fazerBarulho() {
    print('\$nome (\$especie) faz um barulho genérico.');
  }

  void exibirStatus() {
    print('\$nome é um(a) \$especie.');
  }
}

// Subclasse (Classe Filha) que herda de Animal
class Cachorro extends Animal {
  String raca;

  // 1. Usando `super` no construtor da subclasse
  // O construtor da subclasse deve chamar o construtor da superclasse
  // antes de inicializar seus próprios campos, usando `super()`.
  Cachorro(String nome, this.raca) : super(nome, 'Cachorro') {
    print('Construtor de Cachorro chamado para \$nome (\$raca).');
  }

  // Sobrescrevendo um método da superclasse
  @override
  void fazerBarulho() {
    // 2. Usando `super` para chamar o método da superclasse
    // Podemos chamar a implementação original do método 'fazerBarulho' de Animal
    // e adicionar comportamento específico do Cachorro.
    super.fazerBarulho(); // Chama o método fazerBarulho() de Animal
    print('\$nome está latindo: Au Au!');
  }

  // Sobrescrevendo outro método e usando `super` para acessar o atributo da superclasse
  @override
  void exibirStatus() {
    super.exibirStatus(); // Chama o exibirStatus() de Animal
    print('Raça: \$raca.');
  }

  // Método próprio da subclasse
  void buscarBola() {
    print('\$nome está buscando a bola!');
  }
}

class Gato extends Animal {
  String corPelo;

  Gato(String nome, this.corPelo) : super(nome, 'Gato') {
    print('Construtor de Gato chamado para \$nome (\$corPelo).');
  }

  @override
  void fazerBarulho() {
    super.fazerBarulho();
    print('\$nome está miando: Miau!');
  }
}


void main() {
  print('--- Criando um Cachorro ---');
  var meuCachorro = Cachorro('Rex', 'Labrador');
  meuCachorro.fazerBarulho(); // Chama o método sobrescrito em Cachorro
  meuCachorro.exibirStatus(); // Chama o método sobrescrito em Cachorro
  meuCachorro.buscarBola();

  print('\\n--- Criando um Gato ---');
  var meuGato = Gato('Mimi', 'Branco');
  meuGato.fazerBarulho(); // Chama o método sobrescrito em Gato
  meuGato.exibirStatus(); // Chama o método original de Animal (não sobrescrito aqui)
}''',
  output: '''--- Criando um Cachorro ---
Construtor de Animal chamado para Rex (Cachorro).
Construtor de Cachorro chamado para Rex (Labrador).
Rex (Cachorro) faz um barulho genérico.
Rex está latindo: Au Au!
Rex é um(a) Cachorro.
Raça: Labrador.
Rex está buscando a bola!

--- Criando um Gato ---
Construtor de Animal chamado para Mimi (Gato).
Construtor de Gato chamado para Mimi (Branco).
Mimi (Gato) faz um barulho genérico.
Mimi está miando: Miau!
Mimi é um(a) Gato.''',
  description:
      'A palavra-chave `super` em Dart é fundamental em contextos de herança. Ela permite que subclasses chamem o construtor de sua superclasse (`super(...)`) para inicializar a parte herdada do objeto. Além disso, `super` é usada para acessar e invocar métodos ou atributos da superclasse que foram sobrescritos na subclasse, garantindo que a funcionalidade original da classe pai possa ser complementada ou estendida, em vez de completamente substituída.',
);
