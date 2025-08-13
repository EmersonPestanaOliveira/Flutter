// lib/data/topics/oop/abstract_classes.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent abstractClassesTopic = TopicContent(
  title: 'Classes Abstratas', // Título explícito para exibição
  code: '''// Classes Abstratas
// Uma classe abstrata é uma classe que não pode ser instanciada diretamente.
// Ela serve como um "contrato" ou "modelo" para outras classes (subclasses),
// forçando-as a implementar certos métodos ou propriedades.
// Uma classe abstrata pode conter:
// - Métodos abstratos (sem implementação, apenas a assinatura).
// - Métodos concretos (com implementação).
// - Atributos (podem ser abstratos ou concretos, mas a ausência de um valor inicial
//   para um atributo não-nullable em uma classe abstrata é comum).

abstract class FormaGeometrica {
  // Atributo concreto: subclasses herdam e podem usar
  String cor;

  // Construtor concreto: subclasses podem chamar com 'super()'
  FormaGeometrica(this.cor);

  // Método abstrato: Sem corpo (sem implementação).
  // Qualquer subclasse CONCRETA de FormaGeometrica DEVE implementar este método.
  double calcularArea();

  // Método abstrato: Outro exemplo sem corpo.
  void desenhar();

  // Método concreto: Com implementação padrão que subclasses podem usar ou sobrescrever.
  void exibirInformacoes() {
    print('Esta é uma forma geométrica de cor \$cor.');
  }
}

// Classe concreta que herda de FormaGeometrica
// Precisa implementar todos os métodos abstratos da superclasse.
class Circulo extends FormaGeometrica {
  double raio;

  // Construtor do Círculo, chamando o construtor da superclasse com 'super'.
  Circulo(this.raio, String cor) : super(cor);

  // Implementação obrigatória do método abstrato calcularArea
  @override
  double calcularArea() {
    return 3.14159 * raio * raio;
  }

  // Implementação obrigatória do método abstrato desenhar
  @override
  void desenhar() {
    print('Desenhando um círculo de raio \$raio e cor \$cor.');
  }

  // Método específico da subclasse Circulo
  void girar() {
    print('O círculo está girando.');
  }
}

// Outra classe concreta que herda de FormaGeometrica
class Retangulo extends FormaGeometrica {
  double largura;
  double altura;

  Retangulo(this.largura, this.altura, String cor) : super(cor);

  @override
  double calcularArea() {
    return largura * altura;
  }

  @override
  void desenhar() {
    print('Desenhando um retângulo de largura \$largura, altura \$altura e cor \$cor.');
  }
}

void main() {
  print('--- Instanciando Classes Concretas ---');
  // Não podemos instanciar FormaGeometrica diretamente:
  // var forma = FormaGeometrica('Preto'); // Isso causaria um erro de compilação.

  var meuCirculo = Circulo(5.0, 'Azul');
  meuCirculo.exibirInformacoes(); // Método concreto herdado
  meuCirculo.desenhar();           // Método abstrato implementado
  print('Área do Círculo: \${meuCirculo.calcularArea()}');
  meuCirculo.girar();              // Método próprio do Circulo

  print('\\n--- Outra Instância Concreta ---');
  var meuRetangulo = Retangulo(4.0, 6.0, 'Verde');
  meuRetangulo.exibirInformacoes();
  meuRetangulo.desenhar();
  print('Área do Retângulo: \${meuRetangulo.calcularArea()}');

  print('\\n--- Polimorfismo com Classes Abstratas ---');
  // Uma lista de formas pode conter objetos de qualquer subclasse concreta.
  List<FormaGeometrica> formas = [
    Circulo(3.0, 'Vermelho'),
    Retangulo(2.0, 8.0, 'Amarelo'),
  ];

  for (var forma in formas) {
    forma.desenhar(); // O método 'desenhar' específico de cada subclasse é chamado.
    print('Área: \${forma.calcularArea()}');
  }
}''',
  output: '''--- Instanciando Classes Concretas ---
Esta é uma forma geométrica de cor Azul.
Desenhando um círculo de raio 5.0 e cor Azul.
Área do Círculo: 78.53975
O círculo está girando.

--- Outra Instância Concreta ---
Esta é uma forma geométrica de cor Verde.
Desenhando um retângulo de largura 4.0, altura 6.0 e cor Verde.
Área do Retângulo: 24.0

--- Polimorfismo com Classes Abstratas ---
Desenhando um círculo de raio 3.0 e cor Vermelho.
Área: 28.27431
Desenhando um retângulo de largura 2.0, altura 8.0 e cor Amarelo.
Área: 16.0''',
  description:
      'Classes abstratas em Dart são classes que não podem ser instanciadas diretamente e servem como modelos para outras classes. Elas podem conter métodos abstratos (sem implementação, que devem ser implementados pelas subclasses concretas) e métodos concretos (com implementação). Classes abstratas são usadas para definir uma interface comum e um comportamento base para um grupo de classes relacionadas, aplicando o conceito de polimorfismo. Elas forçam que as subclasses concretas forneçam implementações específicas para os métodos abstratos, garantindo um contrato de funcionalidade.',
);
