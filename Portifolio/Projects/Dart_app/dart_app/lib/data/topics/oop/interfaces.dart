// lib/data/topics/oop/interfaces.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent interfacesTopic = TopicContent(
  title: 'Interfaces (implements)', // Título explícito para exibição
  code: '''// Interfaces em Dart
// Em Dart, não existe uma palavra-chave 'interface' explícita como em algumas outras linguagens.
// Qualquer classe (abstrata ou concreta) pode servir como uma interface implícita.
// Quando uma classe usa a palavra-chave 'implements', ela se compromete a fornecer
// uma implementação para TODOS os métodos e atributos da interface implementada.
// Isso é uma forma de garantir um "contrato" de comportamento.

// Exemplo de uma classe que será usada como interface implícita
// Ela define um conjunto de comportamentos que outras classes podem implementar.
class Carroceria {
  void fabricarChassi() {
    print('Fabricando chassi da carroceria.');
  }

  void pintar() {
    print('Pintando a carroceria.');
  }
}

// Outra classe (abstrata) que será usada como interface implícita
// Métodos abstratos em uma interface são uma maneira de forçar a implementação.
abstract class Motor {
  void ligar();
  void desligar();
  int get potencia; // Getters também podem ser parte da interface e devem ser implementados.
}

// Classe que implementa as interfaces Carroceria e Motor
// Isso significa que 'MeuCarro' DEVE fornecer implementações para todos
// os métodos e getters definidos em 'Carroceria' e 'Motor'.
class MeuCarro implements Carroceria, Motor {
  String modelo;
  int _potenciaMotor;

  MeuCarro(this.modelo, this._potenciaMotor);

  // Implementação obrigatória dos métodos da interface Carroceria
  @override
  void fabricarChassi() {
    print('Meu carro \$modelo: Chassi personalizado fabricado.');
  }

  @override
  void pintar() {
    print('Meu carro \$modelo: Pintura especial aplicada.');
  }

  // Implementação obrigatória dos métodos e getters da interface Motor
  @override
  void ligar() {
    print('Meu carro \$modelo: Motor ligado com \$_potenciaMotor cavalos!');
  }

  @override
  void desligar() {
    print('Meu carro \$modelo: Motor desligado.');
  }

  @override
  int get potencia => _potenciaMotor; // Implementação do getter da interface

  // Método próprio da classe MeuCarro
  void dirigir() {
    print('Dirigindo o meu carro \$modelo.');
  }
}

void main() {
  print('--- Implementando Múltiplas Interfaces ---');
  var meuCarro = MeuCarro('Esportivo XYZ', 300);

  // Chamando métodos implementados da interface Carroceria
  meuCarro.fabricarChassi();
  meuCarro.pintar();

  // Chamando métodos e getters implementados da interface Motor
  meuCarro.ligar();
  print('Potência do Motor: \${meuCarro.potencia} CV');
  meuCarro.desligar();

  // Chamando método próprio da classe MeuCarro
  meuCarro.dirigir();

  print('\\n--- Polimorfismo com Interfaces ---');
  // Uma variável do tipo da interface pode referenciar um objeto da classe que a implementa.
  Motor umMotor = MeuCarro('Elétrico Alpha', 450);
  umMotor.ligar();
  print('Potência do Motor Abstrato: \${umMotor.potencia} CV');
  // umMotor.pintar(); // ERRO: 'umMotor' é do tipo Motor, e a interface Motor não tem o método pintar.
                     // A variável só pode acessar membros definidos na sua interface.
}''',
  output: '''--- Implementando Múltiplas Interfaces ---
Meu carro Esportivo XYZ: Chassi personalizado fabricado.
Meu carro Esportivo XYZ: Pintura especial aplicada.
Meu carro Esportivo XYZ: Motor ligado com 300 cavalos!
Potência do Motor: 300 CV
Meu carro Esportivo XYZ: Motor desligado.
Dirigindo o meu carro Esportivo XYZ.

--- Polimorfismo com Interfaces ---
Meu carro Elétrico Alpha: Motor ligado com 450 cavalos!
Potência do Motor Abstrato: 450 CV''',
  description:
      'Em Dart, o conceito de interface é implícito: qualquer classe pode servir como uma interface. Quando uma classe usa a palavra-chave `implements` para implementar outra classe, ela se compromete a fornecer uma implementação para todos os métodos e atributos dessa classe. Isso é útil para definir um "contrato" de comportamento que múltiplas classes podem seguir, permitindo polimorfismo onde objetos de diferentes classes podem ser tratados como do tipo da interface implementada, promovendo um design mais flexível e desacoplado.',
);
