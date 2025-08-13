// lib/data/topics/oop/extension_methods.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent extensionMethodsTopic = TopicContent(
  title:
      'Métodos de Extensão (Extension Methods)', // Título explícito para exibição
  code: '''// Métodos de Extensão (Extension Methods)
// Permitem adicionar novas funcionalidades a classes existentes (suas ou de bibliotecas)
// sem precisar modificá-las, criar subclasses ou usar composição.
// É uma forma poderosa de estender o comportamento de tipos existentes,
// como String, int, List, sem poluir o código original.
// A sintaxe é 'extension NomeDaExtensao on TipoParaExtender'.

// Exemplo 1: Extensão para a classe String
extension StringUtils on String {
  // Getter: Verifica se a string é nula ou vazia.
  // 'this' refere-se à instância da String na qual o método é chamado.
  bool get isNullOrEmpty {
    // Note: 'this' nunca será null se você chamar diretamente em uma String não-nullable.
    // Para lidar com nulos, você precisaria de um tipo nullable (String?).
    return this.isEmpty;
  }

  // Método: Capitaliza a primeira letra de uma string.
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  // Método: Inverte a string.
  String reverse() {
    return this.split('').reversed.join('');
  }
}

// Exemplo 2: Extensão para a classe List<int>
extension ListIntUtils on List<int> {
  // Método: Calcula a soma de todos os elementos inteiros na lista.
  int sum() {
    int total = 0;
    for (var number in this) {
      total += number;
    }
    return total;
  }

  // Método: Encontra o maior número na lista. Retorna null se a lista for vazia.
  int? findMax() {
    if (this.isEmpty) return null;
    int max = this[0];
    for (int i = 1; i < this.length; i++) {
      if (this[i] > max) {
        max = this[i];
      }
    }
    return max;
  }
}

// Você pode estender suas próprias classes também.
// Exemplo 3: Extensão para uma classe personalizada 'Pessoa'.
class Pessoa {
  String primeiroNome;
  String ultimoNome;
  Pessoa(this.primeiroNome, this.ultimoNome);
}

extension PessoaFullName on Pessoa {
  // Getter: Retorna o nome completo da pessoa.
  String get fullName => '\$primeiroNome \$ultimoNome';
}


void main() {
  print('--- Extensão para String ---');
  String saudacao = 'olá mundo';
  String nome = 'alice';
  String vazia = '';

  print('Original: "\$saudacao", Capitalizada: "\${saudacao.capitalize()}"');
  print('Original: "\$nome", Invertida: "\${nome.reverse()}"');
  print('String vazia ("\$vazia") é nula ou vazia? \${vazia.isNullOrEmpty}');

  // Para testar isNullOrEmpty em String? (nullable), precisaríamos de uma variável String?
  String? nulaString;
  // bool isNull = nulaString?.isNullOrEmpty ?? true; // Isso funcionaria se isNullOrEmpty fosse um método, não um getter que usa 'this.isEmpty'
  // Para testar isNullOrEmpty de forma mais robusta com nulos, o getter precisaria ser definido em 'String?'
  // ou a verificação 'this == null' precisa ser explícita no cliente, ou use um 'null check' (nulaString == null || nulaString.isEmpty).
  print('String nula (null) é nula ou vazia? \${nulaString == null || nulaString.isEmpty}');


  print('\\n--- Extensão para List<int> ---');
  List<int> numeros = [10, 20, 5, 30];
  List<int> listaVazia = [];

  print('Soma dos números: \${numeros.sum()}');
  print('Maior número: \${numeros.findMax()}');
  print('Soma da lista vazia: \${listaVazia.sum()}'); // Será 0
  print('Maior da lista vazia: \${listaVazia.findMax()}'); // Será null

  print('\\n--- Extensão para Classes Próprias (Pessoa) ---');
  var pessoa = Pessoa('João', 'Silva');
  print('Nome completo da pessoa: \${pessoa.fullName}');
}''',
  output: '''--- Extensão para String ---
Original: "olá mundo", Capitalizada: "Olá mundo"
Original: "alice", Invertida: "ecila"
String vazia ("") é nula ou vazia? true
String nula (null) é nula ou vazia? true

--- Extensão para List<int> ---
Soma dos números: 65
Maior número: 30
Soma da lista vazia: 0
Maior da lista vazia: null

--- Extensão para Classes Próprias (Pessoa) ---
Nome completo da pessoa: João Silva''',
  description:
      'Métodos de Extensão (Extension Methods) em Dart permitem adicionar novas funcionalidades a classes existentes (incluindo as built-in como `String`, `List`, etc., e suas próprias classes) sem modificar o código-fonte original da classe ou criar subclasses. Eles são definidos usando a palavra-chave `extension` e tornam o código mais limpo e legível, permitindo que você chame os novos métodos como se fizessem parte da classe original. É uma técnica poderosa para melhorar a expressividade e a organização do código.',
);
