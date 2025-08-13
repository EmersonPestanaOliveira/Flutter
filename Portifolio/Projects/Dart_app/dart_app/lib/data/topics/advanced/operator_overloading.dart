// lib/data/topics/advanced/operator_overloading.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent operatorOverloadingTopic = TopicContent(
  title: 'Sobrecarga de Operadores', // Título explícito para exibição
  code: '''// Sobrecarga de Operadores (Operator Overloading)
// A sobrecarga de operadores permite redefinir o comportamento de operadores
// como `+`, `-`, `*`, `/`, `==`, `[]`, etc., para instâncias de suas classes.
// Isso torna o código mais intuitivo e legível ao trabalhar com objetos personalizados.
// Em Dart, você sobrecarrega um operador definindo um método com a palavra-chave `operator`
// seguida pelo símbolo do operador.

// Exemplo 1: Sobrecarga do operador `+` para somar pontos
class Ponto {
  final int x;
  final int y;

  Ponto(this.x, this.y);

  // Sobrecarga do operador `+`
  // Permite somar dois objetos Ponto.
  // O método `operator +` deve retornar um novo objeto Ponto.
  Ponto operator +(Ponto outro) {
    return Ponto(x + outro.x, y + outro.y);
  }

  // Sobrecarga do operador `*` para multiplicar um ponto por um escalar
  Ponto operator *(int escalar) {
    return Ponto(x * escalar, y * escalar);
  }

  // Sobrecarga do operador `==` e `hashCode`
  // Necessário para comparar objetos de forma significativa.
  @override
  bool operator ==(Object outro) {
    return outro is Ponto && outro.x == x && outro.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Ponto(x: \$x, y: \$y)';
}

// Exemplo 2: Sobrecarga do operador `[]` (operador de indexação)
class MinhaListaCustomizada<T> {
  final List<T> _items = [];

  MinhaListaCustomizada();

  // Sobrecarga do operador `[]` (getter)
  // Permite acessar elementos da lista usando índices, como `lista[0]`.
  T operator [](int index) {
    return _items[index];
  }

  // Sobrecarga do operador `[]=` (setter)
  // Permite atribuir valores a um índice específico, como `lista[0] = valor`.
  void operator []=(int index, T value) {
    if (index >= _items.length) {
      // Garante que a lista se expanda se o índice for maior que o tamanho atual
      _items.addAll(List.filled(index - _items.length + 1, null as T)); // Preenche com nulos se necessário
    }
    _items[index] = value;
  }

  void add(T item) {
    _items.add(item);
  }

  int get length => _items.length;

  @override
  String toString() => 'MinhaListaCustomizada(\${_items.join(', ')})';
}

void main() {
  print('--- Sobrecarga do operador "+" e "*" para a classe Ponto ---');
  var p1 = Ponto(10, 20);
  var p2 = Ponto(5, 7);

  // Usa o operador `+` sobrecarregado
  var p3 = p1 + p2;
  print('P1: \$p1');
  print('P2: \$p2');
  print('P1 + P2 = \$p3'); // Saída esperada: Ponto(x: 15, y: 27)

  // Usa o operador `*` sobrecarregado
  var p4 = p1 * 2;
  print('P1 * 2 = \$p4'); // Saída esperada: Ponto(x: 20, y: 40)

  print('\\n--- Sobrecarga do operador "==" para a classe Ponto ---');
  var p5 = Ponto(10, 20);
  var p6 = Ponto(1, 1);
  print('P1 == P5? \${p1 == p5}'); // Saída esperada: true
  print('P1 == P6? \${p1 == p6}'); // Saída esperada: false

  print('\\n--- Sobrecarga do operador "[]" para a classe MinhaListaCustomizada ---');
  var minhaLista = MinhaListaCustomizada<String>();
  minhaLista.add('Maçã');
  minhaLista.add('Banana');
  minhaLista.add('Laranja');

  print('Elementos da lista: \$minhaLista');
  print('Elemento no índice 1: \${minhaLista[1]}'); // Usa operator []

  // Usa operator []= para modificar um elemento
  minhaLista[0] = 'Abacaxi';
  print('Lista após modificar índice 0: \$minhaLista');

  // Adiciona um elemento em um índice maior, expandindo a lista
  minhaLista[5] = 'Uva';
  print('Lista após adicionar no índice 5: \$minhaLista (Tamanho: \${minhaLista.length})');
  print('Elemento no índice 5: \${minhaLista[5]}');
  print('Elemento no índice 3: \${minhaLista[3]}'); // Será null, pois não foi atribuído
}''',
  output: '''--- Sobrecarga do operador "+" e "*" para a classe Ponto ---
P1: Ponto(x: 10, y: 20)
P2: Ponto(x: 5, y: 7)
P1 + P2 = Ponto(x: 15, y: 27)
P1 * 2 = Ponto(x: 20, y: 40)

--- Sobrecarga do operador "==" para a classe Ponto ---
P1 == P5? true
P1 == P6? false

--- Sobrecarga do operador "[]" para a classe MinhaListaCustomizada ---
Elementos da lista: MinhaListaCustomizada(Maçã, Banana, Laranja)
Elemento no índice 1: Banana
Lista após modificar índice 0: MinhaListaCustomizada(Abacaxi, Banana, Laranja)
Lista após adicionar no índice 5: MinhaListaCustomizada(Abacaxi, Banana, Laranja, null, null, Uva) (Tamanho: 6)
Elemento no índice 5: Uva
Elemento no índice 3: null''',
  description:
      'A sobrecarga de operadores em Dart permite que classes personalizadas redefinam o comportamento de operadores (`+`, `-`, `*`, `[]`, `==`, etc.), tornando o código mais expressivo e natural ao manipular objetos. Para sobrecarregar um operador, define-se um método com a palavra-chave `operator` seguida pelo símbolo do operador. Isso é útil para criar APIs que se comportam de forma semelhante aos tipos built-in, melhorando a legibilidade e a intuição do código.',
);
