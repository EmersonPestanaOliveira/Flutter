// lib/data/topics/oop/pass_by_reference.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent passByReferenceTopic = TopicContent(
  title: 'Passagem de Valor (e "Referência" em Dart)',
  code: '''// Em Dart, todos os argumentos são passados por VALOR.
// Para tipos primitivos (int, double, bool, String), uma CÓPIA do valor é passada.
// Para objetos (instâncias de classes), uma CÓPIA da REFERÊNCIA (o endereço de memória) é passada.
// Isso significa que você pode modificar o objeto para o qual a referência aponta,
// mas não pode reatribuir a variável original que foi passada.

class Contador {
  int valor;
  Contador(this.valor);

  void imprimir() {
    print('Contador: \$valor');
  }
}

// Função que modifica um tipo primitivo (int)
void modificarInt(int numero) {
  numero = numero + 10; // Modifica a CÓPIA local de 'numero'
  print('Dentro da função (int): \$numero');
}

// Função que modifica um objeto (passando a referência por valor)
void modificarObjeto(Contador c) {
  c.valor = c.valor + 100; // Modifica o objeto para o qual 'c' aponta
  print('Dentro da função (objeto): \${c.valor}');
}

// Função que tenta reatribuir a referência (não afeta o original)
void reatribuirObjeto(Contador c) {
  c = Contador(500); // 'c' agora aponta para um NOVO objeto local
  print('Dentro da função (reatribuindo): \${c.valor}');
}

void main() {
  print('--- Passagem por Valor (Tipos Primitivos) ---');
  int meuNumero = 5;
  print('Antes da função (int): \$meuNumero');
  modificarInt(meuNumero);
  print('Depois da função (int): \$meuNumero'); // Permanece 5, pois uma cópia foi modificada

  print('\\n--- Passagem de Referência por Valor (Objetos) ---');
  var meuContador = Contador(10);
  print('Antes da função (objeto):');
  meuContador.imprimir();
  modificarObjeto(meuContador); // Modifica o objeto original
  print('Depois da função (objeto):');
  meuContador.imprimir(); // O valor foi alterado para 110

  print('\\n--- Tentando Reatribuir a Referência ---');
  var outroContador = Contador(20);
  print('Antes da reatribuição (objeto original):');
  outroContador.imprimir();
  reatribuirObjeto(outroContador); // A 'referência' local 'c' é reatribuída, não a 'outroContador'
  print('Depois da reatribuição (objeto original):');
  outroContador.imprimir(); // Permanece 20, a reatribuição afetou apenas a cópia da referência
}''',
  output: '''--- Passagem por Valor (Tipos Primitivos) ---
Antes da função (int): 5
Dentro da função (int): 15
Depois da função (int): 5

--- Passagem de Referência por Valor (Objetos) ---
Antes da função (objeto):
Contador: 10
Dentro da função (objeto): 110
Depois da função (objeto):
Contador: 110

--- Tentando Reatribuir a Referência ---
Antes da reatribuição (objeto original):
Contador: 20
Dentro da função (reatribuindo): 500
Depois da reatribuição (objeto original):
Contador: 20''',
  description:
      'Em Dart, todos os argumentos são passados por **valor**. Para tipos primitivos, uma cópia do valor é passada. Para objetos, uma cópia da referência (o ponteiro para o objeto na memória) é passada. Isso significa que você pode modificar o estado do objeto para o qual a referência aponta, mas não pode reatribuir a variável original que foi passada como argumento em escopos externos. Se você reatribuir o parâmetro dentro da função, essa reatribuição afetará apenas a cópia local da referência.',
);
