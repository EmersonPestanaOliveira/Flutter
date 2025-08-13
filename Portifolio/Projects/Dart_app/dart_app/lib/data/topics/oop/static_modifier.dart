// lib/data/topics/oop/static_modifier.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent staticModifierTopic = TopicContent(
  title: 'Modificador static',
  code:
      '''// O modificador 'static' em Dart é usado para membros (atributos e métodos)
// que pertencem à classe em si, e não a uma instância (objeto) específica da classe.
// Você os acessa diretamente através do nome da classe.

class ConfiguracoesApp {
  // Atributo estático: Compartilhado por TODAS as instâncias da classe.
  // Acessado como `ConfiguracoesApp.versao`.
  static const String versao = '1.0.0'; // Constante estática
  static int contadorInstancias = 0; // Variável estática

  // Atributo de instância (não estático)
  String temaAtual;

  ConfiguracoesApp(this.temaAtual) {
    contadorInstancias++; // Incrementa o contador estático a cada nova instância
  }

  // Método estático: Pertence à classe. Não pode acessar atributos de instância
  // diretamente, a menos que uma instância seja passada como parâmetro.
  // Acessado como `ConfiguracoesApp.imprimirInfoGeral()`.
  static void imprimirInfoGeral() {
    print('--- Informações Gerais do App ---');
    print('Versão do Aplicativo: \$versao');
    print('Número de instâncias criadas: \$contadorInstancias');
    // print('Tema atual: \$temaAtual'); // ERRO: Não pode acessar 'temaAtual' (não estático)
  }

  // Método de instância (não estático): Pertence ao objeto.
  // Pode acessar atributos de instância e estáticos.
  void exibirConfiguracoesInstancia() {
    print('\\n--- Configurações da Instância ---');
    print('Tema atual desta instância: \$temaAtual');
    print('Versão global do App (acessando de instância): \${ConfiguracoesApp.versao}');
  }
}

void main() {
  // Acessando membros estáticos diretamente pela classe
  print('Acessando static antes de criar instâncias:');
  ConfiguracoesApp.imprimirInfoGeral();

  // Criando instâncias da classe
  var config1 = ConfiguracoesApp('Dark');
  var config2 = ConfiguracoesApp('Light');
  var config3 = ConfiguracoesApp('System Default');

  // Acessando membros estáticos novamente após criar instâncias
  print('\\nAcessando static depois de criar instâncias:');
  ConfiguracoesApp.imprimirInfoGeral(); // O contador de instâncias foi incrementado

  // Acessando membros de instância através de objetos
  config1.exibirConfiguracoesInstancia();
  config2.exibirConfiguracoesInstancia();

  // Tentando acessar atributo estático de instância (não recomendado, mas possível)
  // print(config1.versao); // Avisos na IDE, mas funciona. Melhor usar ConfiguracoesApp.versao.
}''',
  output: '''Acessando static antes de criar instâncias:
--- Informações Gerais do App ---
Versão do Aplicativo: 1.0.0
Número de instâncias criadas: 0

Acessando static depois de criar instâncias:
--- Informações Gerais do App ---
Versão do Aplicativo: 1.0.0
Número de instâncias criadas: 3

--- Configurações da Instância ---
Tema atual desta instância: Dark
Versão global do App (acessando de instância): 1.0.0

--- Configurações da Instância ---
Tema atual desta instância: Light
Versão global do App (acessando de instância): 1.0.0''',
  description:
      'O modificador `static` em Dart define membros (atributos e métodos) que pertencem à classe em si, em vez de a uma instância específica da classe. Isso significa que eles são compartilhados por todos os objetos da classe e são acessados diretamente pelo nome da classe (ex: `ClassName.staticMember`). Atributos estáticos mantêm um único valor para toda a classe, e métodos estáticos não podem acessar membros não estáticos da classe sem uma instância.',
);
