// lib/data/topics/oop/interfaces_another_use.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent interfacesAnotherUseTopic = TopicContent(
  title: 'Outro Uso para Interfaces', // Título explícito para exibição
  code: '''// Outro Uso para Interfaces (Comportamentos Adicionais)
// Em Dart, qualquer classe pode ser usada como uma interface implícita.
// Isso permite que uma classe "implemente" o comportamento de múltiplas
// outras classes, mesmo que já esteja envolvida em uma hierarquia de herança
// simples (Dart não tem herança múltipla de classes).
// Isso é uma forma de adicionar "capacidades" ou "papéis" a uma classe.

// Classe base principal (poderia ser uma classe de framework, por exemplo)
class EntidadeBase {
  String id;
  EntidadeBase(this.id);

  void salvar() {
    print('Entidade \$_id salva no banco de dados.');
  }
}

// Interface implícita 1: Comportamento de Log
// Uma classe que implementa 'Logavel' se compromete a ter um método 'logar'.
class Logavel {
  void logar(String mensagem) {
    // Implementação padrão ou vazia. Subclasses podem sobrescrever.
    print('[LOG]: \$mensagem');
  }
}

// Interface implícita 2: Comportamento de Notificação
// Uma classe que implementa 'Notificavel' se compromete a ter um método 'notificar'.
class Notificavel {
  void notificar(String destinatario, String assunto, String corpo) {
    print('[NOTIFICACAO] Para: \$destinatario, Assunto: \$assunto, Conteúdo: \$corpo');
  }
}

// Classe que herda de 'EntidadeBase' e implementa 'Logavel' e 'Notificavel'
// Isso mostra como uma classe pode ter uma herança e múltiplos "contratos" de interface.
class UsuarioSistema extends EntidadeBase implements Logavel, Notificavel {
  String nomeUsuario;
  String email;

  UsuarioSistema(String id, this.nomeUsuario, this.email) : super(id);

  // Implementação do método 'logar' da interface 'Logavel'
  @override
  void logar(String mensagem) {
    print('[USUARIO: \$nomeUsuario] LOG: \$mensagem');
  }

  // Implementação do método 'notificar' da interface 'Notificavel'
  @override
  void notificar(String destinatario, String assunto, String corpo) {
    print('[USUARIO: \$nomeUsuario] Enviando notificação para \$destinatario sobre "\$assunto".');
    // Adicionamos a lógica real de notificação aqui
    print('Conteúdo: \$corpo');
  }

  // Método próprio da classe UsuarioSistema
  void autenticar() {
    logar('Tentativa de autenticação de \$nomeUsuario.');
    print('Usuário \$nomeUsuario autenticado com sucesso.');
    notificar(email, 'Login Realizado', 'Você acessou sua conta agora.');
  }

  void deslogar() {
    logar('Usuário \$nomeUsuario deslogou.');
    print('Sessão de \$nomeUsuario encerrada.');
  }
}

// Outra classe que implementa 'Logavel', mostrando reuso do comportamento de log.
class ProcessadorPagamento implements Logavel {
  String transacaoId;

  ProcessadorPagamento(this.transacaoId);

  // Implementação do método 'logar' da interface 'Logavel'
  @override
  void logar(String mensagem) {
    print('[TRANSACAO: \$transacaoId] LOG: \$mensagem');
  }

  void processar() {
    logar('Iniciando processamento da transação.');
    print('Processando pagamento para transação \$transacaoId...');
    logar('Pagamento processado e concluído.');
  }
}


void main() {
  print('--- Usuário do Sistema com Herança e Interfaces ---');
  var user = UsuarioSistema('user_001', 'ana.carvalho', 'ana@email.com');
  user.autenticar();
  user.deslogar();
  user.salvar(); // Método herdado de EntidadeBase

  print('\\n--- Processador de Pagamento usando Interface ---');
  var paymentProcessor = ProcessadorPagamento('PAG_X123');
  paymentProcessor.processar();

  print('\\n--- Polimorfismo com Interfaces ---');
  // Uma lista de objetos que são Logáveis, independentemente da herança.
  List<Logavel> itensLogaveis = [
    user, // UsuarioSistema é Logavel
    paymentProcessor, // ProcessadorPagamento é Logavel
  ];

  for (var item in itensLogaveis) {
    item.logar('Mensagem genérica para log.');
  }
}''',
  output: '''--- Usuário do Sistema com Herança e Interfaces ---
[USUARIO: ana.carvalho] LOG: Tentativa de autenticação de ana.carvalho.
Usuário ana.carvalho autenticado com sucesso.
[USUARIO: ana.carvalho] Enviando notificação para ana@email.com sobre "Login Realizado".
Conteúdo: Você acessou sua conta agora.
[USUARIO: ana.carvalho] LOG: Usuário ana.carvalho deslogou.
Sessão de ana.carvalho encerrada.
Entidade user_001 salva no banco de dados.

--- Processador de Pagamento usando Interface ---
[TRANSACAO: PAG_X123] LOG: Iniciando processamento da transação.
Processando pagamento para transação PAG_X123...
[TRANSACAO: PAG_X123] LOG: Pagamento processado e concluído.

--- Polimorfismo com Interfaces ---
[USUARIO: ana.carvalho] LOG: Mensagem genérica para log.
[TRANSACAO: PAG_X123] LOG: Mensagem genérica para log.''',
  description:
      'Em Dart, o conceito de interface é implícito: qualquer classe pode servir como uma interface. Um "outro uso" poderoso para interfaces é permitir que classes incorporem comportamentos adicionais (`capabilities`), mesmo que já façam parte de uma hierarquia de herança. Ao `implementar` uma ou mais classes (tratadas como interfaces), uma classe se compromete a fornecer a implementação de todos os seus membros. Isso promove o princípio da composição, permitindo que classes ganhem funcionalidades sem a rigidez da herança múltipla, e facilita o polimorfismo ao agrupar objetos por seus comportamentos compartilhados.',
);
