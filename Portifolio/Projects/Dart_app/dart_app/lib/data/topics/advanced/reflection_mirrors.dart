// lib/data/topics/advanced/reflection_mirrors.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent reflectionMirrorsTopic = TopicContent(
  title: 'Reflexão (dart:mirrors)', // Título explícito para exibição
  code: '''// Reflexão (dart:mirrors) em Dart
// A reflexão é a capacidade de um programa inspecionar e modificar sua própria
// estrutura, comportamento e estado em tempo de execução.
// A biblioteca `dart:mirrors` permite inspecionar classes, métodos, campos,
// bibliotecas e outros elementos de um programa Dart.

// IMPORTANTE: A biblioteca `dart:mirrors` é geralmente desaconselhada
// para código de produção no Flutter e em plataformas compiladas (AOT - Ahead-of-Time).
// Isso ocorre porque ela aumenta significativamente o tamanho do binário e
// pode impedir otimizações de compilação. É mais comum em ambientes
// de desenvolvimento, ferramentas, ou em tempo de execução JIT (Just-In-Time)
// como em aplicações de linha de comando ou web (via dart2js).

import 'dart:mirrors'; // Necessário para usar reflexão

class Pessoa {
  String nome;
  int idade;
  double _altura; // Atributo privado

  Pessoa(this.nome, this.idade, this._altura);

  void apresentar() {
    print('Olá, meu nome é \$nome e tenho \$idade anos.');
  }

  String _getInformacaoSecreta() {
    return 'Informação secreta sobre \$nome.';
  }

  // Getter para a altura (acesso público ao atributo privado)
  double get altura => _altura;
}

void main() {
  var pessoa = Pessoa('Alice', 30, 1.65);

  print('--- 1. Inspecionando a Classe em Tempo de Execução ---');
  // Obtém um Mirror para a instância do objeto
  InstanceMirror instanceMirror = reflect(pessoa);
  // Obtém um Mirror para a declaração da classe do objeto
  ClassMirror classMirror = instanceMirror.type;

  print('Nome da Classe: \${MirrorSystem.getName(classMirror.simpleName)}');

  print('\\n--- 2. Acessando Membros (Fields) ---');
  print('Atributos da classe Pessoa:');
  classMirror.declarations.values.forEach((DeclarationMirror declaration) {
    // Filtra apenas os fields (variáveis de instância)
    if (declaration is VariableMirror) {
      String fieldName = MirrorSystem.getName(declaration.simpleName);
      // Tenta obter o valor do campo se for acessível
      try {
        var value = instanceMirror.getField(declaration.simpleName).reflectee;
        print(' - Campo: \$fieldName, Tipo: \${MirrorSystem.getName(declaration.type.simpleName)}, Valor: \$value');
      } catch (e) {
        // Campos privados (_altura) não podem ser acessados diretamente assim via getField
        print(' - Campo: \$fieldName, Tipo: \${MirrorSystem.getName(declaration.type.simpleName)} (Não acessível diretamente via getField)');
      }
    }
  });

  print('\\n--- 3. Invocando Métodos ---');
  // Invocar um método público
  print('Invocando método "apresentar()":');
  instanceMirror.invoke(
      #apresentar, // Symbol do método
      [] // Argumentos do método
  );

  // Tentar invocar um método privado (geralmente não é permitido diretamente sem hacks)
  // Alguns ambientes JIT podem permitir, mas o Dart AOT normalmente restringe isso.
  // print('\\nTentando invocar método privado "_getInformacaoSecreta()":');
  // try {
  //   var returnValue = instanceMirror.invoke(
  //       #_getInformacaoSecreta, // Symbol do método privado
  //       []
  //   ).reflectee;
  //   print('Retorno do método privado: \$returnValue');
  // } catch (e) {
  //   print('Erro ao invocar método privado: \$e');
  // }

  // Acessando um getter
  print('\\n--- 4. Acessando Getters ---');
  var alturaValue = instanceMirror.getField(#altura).reflectee;
  print('Valor do getter "altura": \$alturaValue');

  print('\\n--- 5. Criando Instâncias Dinamicamente ---');
  // Obtém um Mirror da classe Pessoa novamente
  ClassMirror pessoaClassMirror = currentMirrorSystem().findLibrary(#dart_app.data.topics.advanced.reflection_mirrors).declarations[#Pessoa] as ClassMirror; // Substitua pelo caminho real do seu arquivo
  
  if (pessoaClassMirror != null) {
      var novaPessoaInstanceMirror = pessoaClassMirror.newInstance(
          #Pessoa, // Nome do construtor (padrão é o nome da classe)
          ['Bob', 28, 1.75] // Argumentos para o construtor
      );
      Pessoa novaPessoa = novaPessoaInstanceMirror.reflectee;
      print('Nova Pessoa criada dinamicamente:');
      novaPessoa.apresentar();
  } else {
      print('Não foi possível encontrar a ClassMirror para Pessoa.');
  }
}''',
  output: '''--- 1. Inspecionando a Classe em Tempo de Execução ---
Nome da Classe: Pessoa

--- 2. Acessando Membros (Fields) ---
Atributos da classe Pessoa:
 - Campo: nome, Tipo: String, Valor: Alice
 - Campo: idade, Tipo: int, Valor: 30
 - Campo: _altura, Tipo: double (Não acessível diretamente via getField)

--- 3. Invocando Métodos ---
Invocando método "apresentar()":
Olá, meu nome é Alice e tenho 30 anos.

--- 4. Acessando Getters ---
Valor do getter "altura": 1.65

--- 5. Criando Instâncias Dinamicamente ---
Nova Pessoa criada dinamicamente:
Olá, meu nome é Bob e tenho 28 anos.''',
  description:
      'A reflexão em Dart, através da biblioteca `dart:mirrors`, permite que um programa inspecione e manipule sua própria estrutura (classes, métodos, atributos) em tempo de execução. Isso inclui a capacidade de obter informações sobre tipos, invocar métodos dinamicamente, acessar e modificar atributos, e até mesmo instanciar classes por nome. Embora poderosa, a reflexão é geralmente desaconselhada para uso em produção no Flutter e em plataformas compiladas (AOT) devido ao aumento do tamanho do binário e potenciais impactos na otimização.',
);
