// lib/data/topics/oop/methods.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent methodsTopic = TopicContent(
  title: 'Métodos', // Título explícito para exibição
  code: '''class Calculadora {
  // Método que não retorna valor (void) e não recebe parâmetros
  void imprimirMensagem() {
    print('Calculadora pronta para uso!');
  }

  // Método que retorna um valor (double) e recebe dois parâmetros
  double somar(double a, double b) {
    return a + b;
  }

  // Método que retorna um valor (int) e recebe um parâmetro opcional nomeado
  int subtrair({required int num1, int num2 = 0}) {
    return num1 - num2;
  }

  // Método que retorna um valor (String) e usa uma expressão de corpo curta (=>)
  String saudacao(String nome) => 'Olá, \$nome!';

  // Método estático: pertence à classe, não ao objeto
  static double pi() {
    return 3.14159;
  }
}

void main() {
  // Criando um objeto da classe Calculadora
  var calc = Calculadora();

  // Chamando métodos do objeto
  calc.imprimirMensagem();
  print('Soma: \${calc.somar(10.5, 3.2)}');
  print('Subtração: \${calc.subtrair(num1: 20, num2: 7)}');
  print('Subtração com padrão: \${calc.subtrair(num1: 15)}');
  print('Saudação: \${calc.saudacao('Ana')}');

  // Chamando método estático diretamente da classe
  print('Valor de PI (estático): \${Calculadora.pi()}');
}''',
  output: '''Calculadora pronta para uso!
Soma: 13.7
Subtração: 13
Subtração com padrão: 15
Saudação: Olá, Ana!
Valor de PI (estático): 3.14159''',
  description:
      'Em Dart, **métodos** são funções associadas a uma classe. Eles definem o comportamento e as operações que os objetos daquela classe podem realizar. Métodos podem retornar valores, aceitar parâmetros (posicionais, nomeados, opcionais) e até mesmo serem estáticos, pertencendo à classe em vez de uma instância específica.',
);
