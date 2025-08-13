// lib/data/topics/oop/classes_objects_attributes.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent classesObjectsAttributesTopic = TopicContent(
  title: 'Classes, Objetos e Atributos', // Título explícito para exibição
  code: '''// Definição de uma Classe
class Pessoa {
  // Atributos (também conhecidos como variáveis de instância ou propriedades)
  String nome;
  int idade;
  double? altura; // Atributo nullable

  // Construtor: Usado para criar novas instâncias (objetos) da classe
  Pessoa(this.nome, this.idade, {this.altura}); // Construtor com parâmetro nomeado opcional

  // Método: Um comportamento que a classe pode realizar
  void apresentar() {
    print('Olá, meu nome é \$nome e tenho \$idade anos.');
    if (altura != null) {
      print('Minha altura é \$altura metros.');
    }
  }

  // Outro método
  void fazerAniversario() {
    idade++;
    print('\$nome fez aniversário! Agora tem \$idade anos.');
  }
}

void main() {
  // Criando Objetos (instâncias da classe Pessoa)
  var pessoa1 = Pessoa('Alice', 30, altura: 1.65); // Criando um objeto
  var pessoa2 = Pessoa('Bob', 25); // Criando outro objeto sem altura

  // Acessando Atributos dos objetos
  print('Nome da Pessoa 1: \${pessoa1.nome}');
  print('Idade da Pessoa 2: \${pessoa2.idade}');

  // Chamando Métodos dos objetos
  pessoa1.apresentar();
  pessoa2.apresentar();

  pessoa1.fazerAniversario();
  pessoa1.apresentar(); // Verificando a nova idade de Alice
}''',
  output: '''Nome da Pessoa 1: Alice
Idade da Pessoa 2: 25
Olá, meu nome é Alice e tenho 30 anos.
Minha altura é 1.65 metros.
Olá, meu nome é Bob e tenho 25 anos.
Alice fez aniversário! Agora tem 31 anos.
Olá, meu nome é Alice e tenho 31 anos.
Minha altura é 1.65 metros.''',
  description:
      'Em Programação Orientada a Objetos (POO), uma **classe** é um "molde" ou "planta" para criar objetos. Um **objeto** é uma instância concreta de uma classe. **Atributos** são as características ou dados que definem o estado de um objeto, enquanto **métodos** são as ações ou comportamentos que um objeto pode realizar.',
);
