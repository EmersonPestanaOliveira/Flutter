// lib/data/topics/oop/late_modifier.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent lateModifierTopic = TopicContent(
  title: 'Modificador late',
  code: '''// O modificador 'late' em Dart é usado para declarar variáveis
// que serão inicializadas posteriormente.
// Ele é útil quando uma variável não pode ser inicializada no momento da declaração,
// mas você garante que ela será inicializada antes de ser usada pela primeira vez.

class Usuario {
  late String nome; // Será inicializado depois
  late final int id; // Será inicializado uma única vez depois

  // Construtor que não inicializa 'nome' e 'id' diretamente
  Usuario(String nomeInicial) {
    this.nome = nomeInicial; // 'nome' é inicializado aqui
    // 'id' não é inicializado aqui, será feito em outro método ou depois.
  }

  void atribuirId(int valorId) {
    // A primeira atribuição a um campo 'late final' é permitida.
    // Atribuições subsequentes causariam um erro.
    id = valorId;
  }

  // Getter computado que usa um campo 'late'
  String get saudacao {
    // Se 'nome' não fosse inicializado antes de 'saudacao' ser acessado,
    // um erro em tempo de execução seria lançado.
    return 'Olá, \$nome!';
  }
}

// Variável global 'late'
late String configuracaoGlobal;

void main() {
  print('--- Exemplo com 'late' em classe ---');
  var user = Usuario('Ana');
  // user.id; // ERRO: 'id' não foi inicializado ainda!

  print('Nome do usuário: \${user.nome}');
  print(user.saudacao); // 'nome' já foi inicializado no construtor

  user.atribuirId(123); // 'id' é inicializado aqui
  print('ID do usuário: \${user.id}');

  // user.id = 456; // ERRO: 'id' é 'late final' e já foi inicializado.

  print('\\n--- Exemplo com 'late' global ---');
  // configuracaoGlobal; // ERRO: 'configuracaoGlobal' não foi inicializada ainda!

  configuracaoGlobal = 'Modo Escuro'; // Primeira e única inicialização
  print('Configuração global: \$configuracaoGlobal');

  // Caso de uso: inicialização pesada/assíncrona
  // late Future<String> dadosFuturos = buscarDados();
  // print(await dadosFuturos); // A Future é executada apenas quando acessada

  print('\\n--- Casos de erro comuns com 'late' ---');
  // Variável late não inicializada antes do uso
  // late String naoInicializada;
  // print(naoInicializada); // Erro de tempo de execução: LateInitializationError

  // Variável late final atribuída mais de uma vez
  // late final int valorUnico;
  // valorUnico = 10;
  // valorUnico = 20; // Erro de tempo de execução: LateInitializationError
}
''',
  output: '''--- Exemplo com 'late' em classe ---
Nome do usuário: Ana
Olá, Ana!
ID do usuário: 123

--- Exemplo com 'late' global ---
Configuração global: Modo Escuro

--- Casos de erro comuns com 'late' ---
(Observação: Os erros 'LateInitializationError' seriam mostrados no console em tempo de execução se as linhas comentadas fossem descomentadas.)''',
  description:
      'O modificador `late` em Dart é usado para variáveis que são declaradas como não-nulas (`non-nullable`) mas que não podem ser inicializadas no momento da declaração. Isso permite que você adie a inicialização, mas exige que você garanta que a variável será inicializada antes de seu primeiro uso. Se uma variável `late` for acessada antes de ser inicializada, um `LateInitializationError` será lançado em tempo de execução. `late final` é para valores que serão inicializados apenas uma vez, de forma tardia.',
);
