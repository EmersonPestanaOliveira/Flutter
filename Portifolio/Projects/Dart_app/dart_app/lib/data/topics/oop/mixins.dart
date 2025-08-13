// lib/data/topics/oop/mixins.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent mixinsTopic = TopicContent(
  title: 'Mixins', // Título explícito para exibição
  code: '''// Mixins em Dart
// Mixins são uma forma de reutilizar o código de uma classe em várias
// hierarquias de classes, sem a necessidade de herança (uma classe só pode
// estender uma única outra classe, mas pode usar múltiplos mixins).
// Usa a palavra-chave 'with'.
// Mixins não podem ser instanciados por si próprios e não podem ter construtores.
// Eles adicionam a funcionalidade de seus métodos e atributos à classe que os usa.

// Mixin 1: Comportamento de Comunicação
mixin Comunicador {
  void enviarMensagem(String destinatario, String mensagem) {
    print('[Comunicador] Mensagem para \$destinatario: "\$mensagem"');
  }

  void receberMensagem(String remetente, String mensagem) {
    print('[Comunicador] Recebido de \$remetente: "\$mensagem"');
  }
}

// Mixin 2: Comportamento de Log
mixin Logavel {
  void logarEvento(String evento) {
    print('[LOG] Evento: \$evento');
  }
}

// Classe base (pode ser uma classe normal que será estendida)
class Entidade {
  String id;
  Entidade(this.id);
  void exibirId() {
    print('ID da Entidade: \$id');
  }
}

// Classe que estende 'Entidade' e usa o mixin 'Comunicador'
// 'Usuario' agora tem os métodos de 'Entidade' e 'Comunicador'.
class Usuario extends Entidade with Comunicador {
  String nome;
  Usuario(String id, this.nome) : super(id);

  void apresentar() {
    print('Usuário: \$nome (ID: \$id)');
  }
}

// Outra classe que estende 'Entidade' e usa múltiplos mixins
// 'ServidorDeEmail' agora tem os métodos de 'Entidade', 'Comunicador' e 'Logavel'.
class ServidorDeEmail extends Entidade with Comunicador, Logavel {
  String endereco;
  ServidorDeEmail(String id, this.endereco) : super(id);

  void iniciarServidor() {
    exibirId(); // Método da classe base 'Entidade'
    logarEvento('Servidor \$endereco iniciando...'); // Método do mixin 'Logavel'
    print('Servidor de E-mail \$_endereco online.');
  }

  void enviarEmail(String para, String assunto, String corpo) {
    enviarMensagem(para, 'Assunto: \$assunto, Corpo: \$corpo'); // Método do mixin 'Comunicador'
    logarEvento('Email enviado para \$para com assunto "\$assunto"');
  }
}

// Mixin com requisito 'on'
// O 'on Usuario' significa que 'Notificavel' só pode ser usado por classes
// que estendem (ou implementam) 'Usuario' ou um subtipo de 'Usuario'.
// Isso garante que o mixin tenha acesso aos membros de 'Usuario' (como 'nome').
mixin Notificavel on Usuario {
  void notificarUsuario(String mensagem) {
    print('[NOTIFICACAO] Notificando \${this.nome} (ID:\${this.id}): \$mensagem');
  }
}

// Classe que estende 'Usuario' e usa o mixin 'Notificavel'
class UsuarioPremium extends Usuario with Notificavel {
  UsuarioPremium(String id, String nome) : super(id, nome);
}


void main() {
  print('--- Usuário com Mixin Comunicador ---');
  var user1 = Usuario('user_001', 'Alice');
  user1.apresentar();
  user1.enviarMensagem('Bob', 'Olá, tudo bem?');
  user1.receberMensagem('Bob', 'Tudo ótimo, e você?');

  print('\\n--- Servidor de E-mail com Múltiplos Mixins ---');
  var emailServer = ServidorDeEmail('srv_email_01', 'mail.example.com');
  emailServer.iniciarServidor();
  emailServer.enviarEmail('charlie@email.com', 'Teste de Mixin', 'Este é um e-mail de teste de mixin.');

  print('\\n--- Usuário Premium com Mixin Requerido (on) ---');
  var userPremium = UsuarioPremium('user_premium_001', 'David');
  userPremium.apresentar();
  userPremium.notificarUsuario('Sua assinatura premium foi ativada!');
  userPremium.enviarMensagem('Eve', 'Enviando mensagem como usuário premium.');

  print('\\n--- Polimorfismo com Mixins ---');
  // Você pode tratar objetos que usam um mixin como sendo do tipo do mixin.
  List<Comunicador> comunicadores = [
    user1,
    emailServer,
    userPremium,
  ];

  for (var c in comunicadores) {
    c.enviarMensagem('Central', 'Status de funcionamento.');
  }
}''',
  output: '''--- Usuário com Mixin Comunicador ---
Usuário: Alice (ID: user_001)
[Comunicador] Mensagem para Bob: "Olá, tudo bem?"
[Comunicador] Recebido de Bob: "Tudo ótimo, e você?"

--- Servidor de E-mail com Múltiplos Mixins ---
ID da Entidade: srv_email_01
[LOG] Evento: Servidor mail.example.com iniciando...
Servidor de E-mail mail.example.com online.
[Comunicador] Mensagem para charlie@email.com: "Assunto: Teste de Mixin, Corpo: Este é um e-mail de teste de mixin."
[LOG] Evento: Email enviado para charlie@email.com com assunto "Teste de Mixin"

--- Usuário Premium com Mixin Requerido (on) ---
Usuário: David (ID: user_premium_001)
[NOTIFICACAO] Notificando David (ID:user_premium_001): Sua assinatura premium foi ativada!
[Comunicador] Mensagem para Eve: "Enviando mensagem como usuário premium."

--- Polimorfismo com Mixins ---
[Comunicador] Mensagem para Central: "Status de funcionamento."
[Comunicador] Mensagem para Central: "Status de funcionamento."
[Comunicador] Mensagem para Central: "Status de funcionamento."''',
  description:
      'Mixins em Dart oferecem uma poderosa forma de reutilização de código que não se encaixa na hierarquia de herança tradicional. Eles permitem adicionar funcionalidades (métodos e atributos) de uma ou mais "classes-mixin" a qualquer classe usando a palavra-chave `with`, sem a necessidade de herança explícita. Mixins não podem ser instanciados e não têm construtores. O modificador `on` em um mixin pode ser usado para especificar que ele só pode ser aplicado a classes que são subtipos de uma determinada classe, garantindo o acesso a membros específicos da classe base.',
);
