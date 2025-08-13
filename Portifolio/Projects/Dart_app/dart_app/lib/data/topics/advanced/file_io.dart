// lib/data/topics/advanced/file_io.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent fileIoTopic = TopicContent(
  title: 'Manipulação de Arquivos e I/O', // Título explícito para exibição
  code: '''// Manipulação de Arquivos e Entrada/Saída (I/O) em Dart
// A biblioteca `dart:io` fornece classes para trabalhar com arquivos e diretórios,
// permitindo ler e escrever dados em arquivos, criar e gerenciar diretórios,
// e interagir com o sistema de arquivos.

import 'dart:io'; // Necessário para operações de arquivo
import 'dart:convert'; // Necessário para codificação/decodificação de texto

void main() async { // Usamos 'async' porque operações de I/O são assíncronas
  final String fileName = 'meu_arquivo.txt';
  final String dirName = 'meu_diretorio';
  final String filePath = '\$dirName/\$fileName';

  // --- 1. Escrever em um arquivo ---
  print('--- Escrevendo em um arquivo ---');
  File file = File(filePath);
  Directory directory = Directory(dirName);

  // Criar o diretório se ele não existir
  if (!await directory.exists()) {
    await directory.create();
    print('Diretório "\$dirName" criado.');
  }

  // Escrever uma string no arquivo (sobrescreve se o arquivo já existir)
  await file.writeAsString('Olá, mundo do Dart I/O!\\n');
  await file.writeAsString('Esta é a segunda linha.', mode: FileMode.append); // Adicionar ao final
  print('Conteúdo escrito em "\$filePath".');

  // --- 2. Ler de um arquivo ---
  print('\\n--- Lendo de um arquivo ---');
  if (await file.exists()) { // Verifica se o arquivo existe
    String contents = await file.readAsString();
    print('Conteúdo de "\$filePath":\\n\$contents');

    // Ler linha por linha
    print('Lendo linha por linha:');
    List<String> lines = await file.readAsLines();
    for (int i = 0; i < lines.length; i++) {
      print('Linha \${i + 1}: \${lines[i]}');
    }

    // Lendo como Stream de bytes (útil para grandes arquivos ou dados binários)
    // await for (var byte in file.openRead()) {
    //   print('Bytes lidos: \$byte');
    // }

  } else {
    print('Arquivo "\$filePath" não encontrado para leitura.');
  }

  // --- 3. Manipulação de Diretórios ---
  print('\\n--- Manipulação de Diretórios ---');
  final String newDirName = 'novo_diretorio';
  Directory newDirectory = Directory(newDirName);

  if (await newDirectory.exists()) {
    await newDirectory.delete(recursive: true); // Exclui o diretório e seu conteúdo
    print('Diretório "\$newDirName" existente excluído.');
  }

  await newDirectory.create();
  print('Diretório "\$newDirName" criado.');

  // Renomear um arquivo
  final String oldFilePath = filePath;
  final String newFileName = 'renomeado_arquivo.txt';
  final String newFilePath = '\$dirName/\$newFileName';

  if (await File(oldFilePath).exists()) {
    await File(oldFilePath).rename(newFilePath);
    print('Arquivo "\$oldFilePath" renomeado para "\$newFilePath".');
  }

  // --- 4. Excluindo Arquivos e Diretórios ---
  print('\\n--- Excluindo Arquivos e Diretórios ---');
  if (await File(newFilePath).exists()) {
    await File(newFilePath).delete();
    print('Arquivo "\$newFilePath" excluído.');
  } else if (await File(oldFilePath).exists()){
     // Se o arquivo não foi renomeado (teste em sistema de arquivos real), exclua o original.
     await File(oldFilePath).delete();
     print('Arquivo original "\$oldFilePath" excluído (caso não renomeado antes).');
  }


  // Excluir o diretório criado inicialmente e seu conteúdo
  if (await directory.exists()) {
    await directory.delete(recursive: true); // 'recursive: true' é importante para excluir conteúdo
    print('Diretório "\$dirName" excluído recursivamente.');
  }

  if (await newDirectory.exists()) {
    await newDirectory.delete();
    print('Diretório "\$newDirName" excluído.');
  }

  // --- 5. Lidando com erros (try-catch) ---
  print('\\n--- Lidando com Erros ---');
  try {
    await File('arquivo_inexistente.txt').readAsString();
  } on FileSystemException catch (e) {
    print('Erro de sistema de arquivos ao tentar ler arquivo inexistente: \${e.message}');
  } catch (e) {
    print('Erro genérico: \$e');
  }

  // Finalize as operações pendentes antes de encerrar o programa.
  await Future.delayed(Duration(milliseconds: 100)); // Pequeno delay para garantir que tudo foi processado.
}''',
  output: '''--- Escrevendo em um arquivo ---
Diretório "meu_diretorio" criado.
Conteúdo escrito em "meu_diretorio/meu_arquivo.txt".

--- Lendo de um arquivo ---
Conteúdo de "meu_diretorio/meu_arquivo.txt":
Olá, mundo do Dart I/O!
Esta é a segunda linha.
Lendo linha por linha:
Linha 1: Olá, mundo do Dart I/O!
Linha 2: Esta é a segunda linha.

--- Manipulação de Diretórios ---
Diretório "novo_diretorio" criado.
Arquivo "meu_diretorio/meu_arquivo.txt" renomeado para "meu_diretorio/renomeado_arquivo.txt".

--- Excluindo Arquivos e Diretórios ---
Arquivo "meu_diretorio/renomeado_arquivo.txt" excluído.
Diretório "meu_diretorio" excluído recursivamente.
Diretório "novo_diretorio" excluído.

--- Lidando com Erros ---
Erro de sistema de arquivos ao tentar ler arquivo inexistente: Cannot open file, path = 'arquivo_inexistente.txt' (OS Error: No such file or directory, errno = 2)''',
  description:
      'A manipulação de Arquivos e Entrada/Saída (I/O) em Dart é realizada principalmente através da biblioteca `dart:io`. Ela oferece classes como `File` para operações com arquivos (leitura, escrita, exclusão, renomeação) e `Directory` para operações com diretórios (criação, exclusão, listagem de conteúdo). As operações de I/O são frequentemente assíncronas para evitar o bloqueio da interface do usuário em aplicações gráficas, utilizando `Future`s e `async`/`await`. É crucial lidar com exceções (`try-catch`) para garantir a robustez do código ao interagir com o sistema de arquivos.',
);
