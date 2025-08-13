// lib/data/topics/oop/method_override.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent methodOverrideTopic = TopicContent(
  title: 'Reescrita de Métodos (@override)', // Título explícito para exibição
  code: '''// Reescrita de Métodos (Method Overriding)
// A reescrita de métodos permite que uma subclasse (classe filha) forneça
// uma implementação específica para um método que já é definido em sua superclasse (classe pai).
// A anotação '@override' é opcional, mas fortemente recomendada em Dart
// para clareza e para que o compilador verifique se você está realmente sobrescrevendo
// um método existente e não criando um novo por engano.

class Veiculo {
  String marca;

  Veiculo(this.marca);

  // Método na superclasse
  void acelerar() {
    print('\$marca está acelerando.');
  }

  // Outro método na superclasse
  void frear() {
    print('\$marca está freando.');
  }
}

class Carro extends Veiculo {
  String modelo;

  Carro(String marca, this.modelo) : super(marca);

  // Reescrita (Override) do método 'acelerar' da superclasse Veiculo.
  // O '@override' indica que este método substitui um método com a mesma assinatura na superclasse.
  @override
  void acelerar() {
    print('O carro \$marca \$modelo está acelerando com mais potência e suavidade.');
  }

  // Reescrita (Override) do método 'frear'.
  @override
  void frear() {
    print('O carro \$marca \$modelo está aplicando os freios ABS e controlando a derrapagem.');
    // Você pode chamar o método da superclasse dentro do método sobrescrito usando 'super.'.
    // super.frear(); // Descomente para ver a chamada ao método original do Veiculo.
  }

  // Método específico da classe Carro
  void ligarRadio() {
    print('Rádio do \$modelo ligado.');
  }
}

class Moto extends Veiculo {
  Moto(String marca) : super(marca);

  // Reescrita do método 'acelerar' para a Moto.
  @override
  void acelerar() {
    print('A moto \$marca está acelerando com um ronco alto e agilidade.');
  }

  // O método 'frear' NÃO foi sobrescrito na Moto, então ela usará a implementação da superclasse.
  void empinar() {
    print('A moto \$marca está empinando!');
  }
}

void main() {
  print('--- Veículo Genérico ---');
  var veiculoGenerico = Veiculo('MarcaGenérica');
  veiculoGenerico.acelerar();
  veiculoGenerico.frear();

  print('\\n--- Carro (com Métodos Sobrescritos) ---');
  var meuCarro = Carro('Honda', 'Civic');
  meuCarro.acelerar(); // Chama o método 'acelerar' reescrito em Carro.
  meuCarro.frear();   // Chama o método 'frear' reescrito em Carro.
  meuCarro.ligarRadio();

  print('\\n--- Moto (com um Método Sobrescrito e outro Herdado) ---');
  var minhaMoto = Moto('Yamaha');
  minhaMoto.acelerar(); // Chama o método 'acelerar' reescrito em Moto.
  minhaMoto.frear();    // Chama o método 'frear' ORIGINAL de Veiculo (não sobrescrito em Moto).
  minhaMoto.empinar();

  print('\\n--- Polimorfismo e Reescrita ---');
  // Uma variável do tipo da superclasse pode referenciar um objeto de qualquer subclasse.
  // O método que será executado é determinado pelo TIPO REAL do objeto em tempo de execução.
  Veiculo v1 = Carro('Ford', 'Focus');
  Veiculo v2 = Moto('Kawasaki');

  print('Com v1 (que é um Carro):');
  v1.acelerar(); // Chama o acelerar do Carro
  print('Com v2 (que é uma Moto):');
  v2.acelerar(); // Chama o acelerar da Moto
}''',
  output: '''--- Veículo Genérico ---
MarcaGenérica está acelerando.
MarcaGenérica está freando.

--- Carro (com Métodos Sobrescritos) ---
O carro Honda Civic está acelerando com mais potência e suavidade.
O carro Honda Civic está aplicando os freios ABS e controlando a derrapagem.
Rádio do Civic ligado.

--- Moto (com um Método Sobrescrito e outro Herdado) ---
A moto Yamaha está acelerando com um ronco alto e agilidade.
A moto Yamaha está freando.
A moto Yamaha está empinando!

--- Polimorfismo e Reescrita ---
Com v1 (que é um Carro):
O carro Ford Focus está acelerando com mais potência e suavidade.
Com v2 (que é uma Moto):
A moto Kawasaki está acelerando com um ronco alto e agilidade.''',
  description:
      'A reescrita de métodos (`@override`) em Dart é um recurso de Programação Orientada a Objetos que permite que uma subclasse forneça uma implementação especializada para um método que já está definido em sua superclasse. A anotação `@override` é opcional, mas seu uso é uma boa prática, pois ajuda o compilador a verificar a correção da sobrescrita e melhora a legibilidade do código. Este mecanismo é fundamental para o polimorfismo, onde diferentes objetos (de subclasses) podem responder de maneiras únicas a uma mesma chamada de método definida na superclasse.',
);
