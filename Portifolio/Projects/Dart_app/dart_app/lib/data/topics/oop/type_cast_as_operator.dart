// lib/data/topics/oop/type_cast_as_operator.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent typeCastAsOperatorTopic = TopicContent(
  title: 'Casting de Tipos (Operador `as`)', // Título explícito para exibição
  code: '''// Casting de Tipos (Operador `as`)
// Em Dart, o operador `as` é usado para realizar um "type cast",
// ou seja, para converter um objeto de um tipo para outro tipo.
// Ele é geralmente usado quando você tem uma referência de um tipo mais genérico
// (como uma superclasse ou interface) e você sabe que o objeto real é de um tipo
// mais específico (uma subclasse ou uma classe que implementa a interface).

// É importante notar que o `as` realiza um "downcast" - ele tenta tratar
// um objeto como um tipo mais específico. Se o cast não for possível,
// ele lançará uma exceção (RuntimeError).

class Animal {
  String nome;
  Animal(this.nome);
  void fazerBarulho() {
    print('\$nome faz um barulho genérico.');
  }
}

class Cachorro extends Animal {
  Cachorro(String nome) : super(nome);
  void latir() {
    print('\$nome está latindo: Au Au!');
  }
}

class Gato extends Animal {
  Gato(String nome) : super(nome);
  void miar() {
    print('\$nome está miando: Miau!');
  }
}

void main() {
  print('--- Exemplo Básico de Casting com `as` ---');
  Animal meuAnimal = Cachorro('Rex'); // 'meuAnimal' é do tipo Animal, mas o objeto é Cachorro.

  // Sem casting, não podemos acessar métodos específicos de Cachorro.
  meuAnimal.fazerBarulho();
  // meuAnimal.latir(); // Erro de compilação: O tipo 'Animal' não tem o método 'latir'.

  // Realizando o casting para Cachorro usando 'as'.
  // Isso informa ao compilador que estamos tratando 'meuAnimal' como um 'Cachorro'.
  Cachorro meuCachorro = meuAnimal as Cachorro;
  meuCachorro.latir(); // Agora podemos chamar 'latir'.

  print('\\n--- Casting em Lista Heterogênea ---');
  List<Animal> animais = [
    Cachorro('Buddy'),
    Gato('Fifi'),
    Cachorro('Max'),
  ];

  for (var animal in animais) {
    animal.fazerBarulho();
    // Para chamar métodos específicos, precisamos verificar o tipo e fazer o casting.
    if (animal is Cachorro) {
      // 'is' é um operador de verificação de tipo.
      // Dentro deste bloco 'if', 'animal' é automaticamente "promovido" para Cachorro.
      animal.latir(); // Não precisa de 'as' aqui, pois Dart faz o smart cast.
    } else if (animal is Gato) {
      animal.miar();
    }
  }

  print('\\n--- Quando o Casting com `as` pode falhar (Runtime Error) ---');
  Animal outroAnimal = Gato('Mia');

  try {
    // Isso vai falhar em tempo de execução porque 'outroAnimal' é um Gato, não um Cachorro.
    Cachorro tentarCastingFalho = outroAnimal as Cachorro;
    tentarCastingFalho.latir(); // Esta linha nunca será alcançada.
  } catch (e) {
    print('Erro de Casting (RuntimeError): \$e');
    print('Não é possível converter Gato para Cachorro.');
  }

  print('\\n--- Casting Seguro com `as?` (para tipos nullables) ---');
  // O operador `as?` (casting condicional) tenta fazer o cast e, se falhar, retorna `null`
  // em vez de lançar uma exceção. Isso é útil para lidar com tipos nullables.
  Animal? animalNull = null;
  Cachorro? cachorroNull = animalNull as Cachorro?; // Resulta em null, sem erro.
  print('Casting de null: \${cachorroNull == null}');

  Animal algumAnimal = Gato('Whiskers');
  Cachorro? talvezCachorro = algumAnimal as Cachorro?; // Retorna null porque 'algumAnimal' é Gato.
  print('Casting de Gato para Cachorro com as?: \${talvezCachorro == null}');

  Cachorro umCachorroDeVerdade = Cachorro('Snoopy');
  Cachorro? castComSucesso = umCachorroDeVerdade as Cachorro?; // Retorna a instância do Cachorro.
  print('Casting de Cachorro para Cachorro com as?: \${castComSucesso != null && castComSucesso.nome == "Snoopy"}');

}''',
  output: '''--- Exemplo Básico de Casting com `as` ---
Rex faz um barulho genérico.
Rex está latindo: Au Au!

--- Casting em Lista Heterogênea ---
Buddy faz um barulho genérico.
Buddy está latindo: Au Au!
Fifi faz um barulho genérico.
Fifi está miando: Miau!
Max faz um barulho genérico.
Max está latindo: Au Au!

--- Quando o Casting com `as` pode falhar (Runtime Error) ---
Erro de Casting (RuntimeError): type 'Gato' is not a subtype of type 'Cachorro' in type cast
Não é possível converter Gato para Cachorro.

--- Casting Seguro com `as?` (para tipos nullables) ---
Casting de null: true
Casting de Gato para Cachorro com as?: true
Casting de Cachorro para Cachorro com as?: true''',
  description:
      'O operador `as` em Dart é usado para realizar um "type cast", que tenta converter um objeto de um tipo para outro tipo mais específico. Ele é comumente empregado ao trabalhar com polimorfismo, onde uma variável de um tipo mais genérico (superclasse ou interface) contém uma instância de um tipo mais específico (subclasse). O `as` pode lançar um erro em tempo de execução se o casting não for válido. Para um casting mais seguro com tipos `nullable`, o operador `as?` pode ser usado, que retorna `null` em caso de falha em vez de lançar uma exceção.',
);
