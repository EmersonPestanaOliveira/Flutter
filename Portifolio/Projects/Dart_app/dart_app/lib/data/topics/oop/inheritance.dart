// lib/data/topics/oop/inheritance.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent inheritanceTopic = TopicContent(
  title: 'Herança', // Título explícito para exibição
  code: '''// Herança em Programação Orientada a Objetos (POO)
// É um mecanismo que permite que uma nova classe (subclasse ou classe filha)
// adquira as propriedades (atributos) e comportamentos (métodos) de uma
// classe existente (superclasse ou classe pai).
// Em Dart, usamos a palavra-chave 'extends' para indicar herança.

// Superclasse (Classe Pai)
class Animal {
  String nome;
  int idade;

  // Construtor da superclasse
  Animal(this.nome, this.idade);

  // Método da superclasse
  void comer() {
    print('\$nome está comendo.');
  }

  // Outro método da superclasse
  void dormir() {
    print('\$nome está dormindo.');
  }
}

// Subclasse (Classe Filha) que herda de Animal
// Um 'Cachorro' é um tipo de 'Animal'.
class Cachorro extends Animal {
  String raca;

  // Construtor do Cachorro
  // O construtor da subclasse DEVE chamar o construtor da superclasse
  // usando 'super()' antes de inicializar seus próprios campos.
  Cachorro(String nome, int idade, this.raca) : super(nome, idade);

  // Método específico da subclasse Cachorro
  void latir() {
    print('\$nome está latindo: Au Au!');
  }

  // É possível sobrescrever métodos da superclasse (ver próximo tópico).
  // Exemplo (comentado):
  // @override
  // void comer() {
  //   print('\$nome está mastigando ração de cachorro.');
  // }
}

// Outra Subclasse que herda de Animal
// Um 'Gato' é um tipo de 'Animal'.
class Gato extends Animal {
  String corPelo;

  Gato(String nome, int idade, this.corPelo) : super(nome, idade);

  void miar() {
    print('\$nome está miando: Miau!');
  }
}

void main() {
  print('--- Criando Objeto da Superclasse (Animal) ---');
  var animalGenerico = Animal('Leão', 5);
  animalGenerico.comer();
  animalGenerico.dormir();

  print('\\n--- Criando Objeto da Subclasse (Cachorro) ---');
  var meuCachorro = Cachorro('Rex', 3, 'Labrador');
  print('Nome do cachorro: \${meuCachorro.nome}');     // Atributo herdado
  print('Idade do cachorro: \${meuCachorro.idade}');   // Atributo herdado
  print('Raça do cachorro: \${meuCachorro.raca}');     // Atributo próprio
  meuCachorro.comer();    // Método herdado de Animal
  meuCachorro.dormir();   // Método herdado de Animal
  meuCachorro.latir();    // Método próprio de Cachorro

  print('\\n--- Criando Objeto da Subclasse (Gato) ---');
  var meuGato = Gato('Mimi', 2, 'Branco');
  print('Nome do gato: \${meuGato.nome}');
  print('Idade do gato: \${meuGato.idade}');
  print('Cor do pelo do gato: \${meuGato.corPelo}');
  meuGato.comer(); // Método herdado de Animal
  meuGato.miar();  // Método próprio de Gato

  print('\\n--- Polimorfismo com Herança ---');
  // Uma variável do tipo da superclasse pode referenciar um objeto de qualquer subclasse.
  Animal umBicho = Cachorro('Buddy', 4, 'Beagle');
  umBicho.comer(); // Chama o método 'comer' do Animal (ou do Cachorro se sobrescrito)
  // umBicho.latir(); // ERRO: 'latir' não é um método de Animal, apenas de Cachorro.
                     // Para chamar latir, 'umBicho' precisaria ser explicitamente castado para Cachorro.
}''',
  output: '''--- Criando Objeto da Superclasse (Animal) ---
Leão está comendo.
Leão está dormindo.

--- Criando Objeto da Subclasse (Cachorro) ---
Nome do cachorro: Rex
Idade do cachorro: 3
Raça do cachorro: Labrador
Rex está comendo.
Rex está dormindo.
Rex está latindo: Au Au!

--- Criando Objeto da Subclasse (Gato) ---
Nome do gato: Mimi
Idade do gato: 2
Cor do pelo do gato: Branco
Mimi está comendo.
Mimi está miando: Miau!

--- Polimorfismo com Herança ---
Buddy está comendo.''',
  description:
      'Herança em Programação Orientada a Objetos é um pilar que permite que uma classe (subclasse) reutilize e estenda o código de outra classe (superclasse). Em Dart, a palavra-chave `extends` é usada para estabelecer essa relação "é um tipo de" (e.g., um `Cachorro` *é um tipo de* `Animal`). A subclasse herda atributos e métodos da superclasse, podendo adicionar os seus próprios ou sobrescrever os herdados.',
);
