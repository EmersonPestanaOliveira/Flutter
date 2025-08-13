import 'package:dart_app/dart_pad_view_screen.dart';
import 'package:dart_app/data/study_data_model.dart';
import 'package:flutter/material.dart';
import 'package:dart_app/topic_detail_screen.dart';
import 'package:dart_app/data/topic_registry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AQUI É ONDE ESTÁ A MUDANÇA CRUCIAL:
  // A lista de categorias é definida diretamente aqui,
  // pois você não está importando uma variável 'allStudyCategories' de outro lugar.
  final List<StudyCategory> _categories = [
    StudyCategory(
      title: 'Fundamentos do Dart',
      icon: Icons.foundation,
      topicKeys: [
        'hello_world', // Confirmar se a chave é 'hello_world' ou 'hello_word'
        'comments',
        'constants', // <-- Adicionado (chave para constantsTopic)
        'variables',
        'operators',
        'conditional_structures', // <-- Adicionado (chave para conditionalStructuresTopic)
        'loop_structures', // <-- Adicionado (chave para loopStructuresTopic)
        'functions', // <-- Adicionado (chave para functionsTopic)
        'null_safety', // <-- Adicionado (chave para nullSafetyTopic)
        'errors', // <-- Adicionado (chave para errorsTopic)
        'enums',
        'loop_structures',
        'async_await',
      ],
    ),
    StudyCategory(
      title: 'Programação Orientada a Objetos',
      icon: Icons.extension,
      topicKeys: [
        'classes_objects_attributes',
        'methods',
        'constructors', // <-- ADICIONAR
        'getters_setters', // <-- ADICIONAR
        'static_modifier', // <-- ADICIONAR
        'late_modifier', // <-- ADICIONAR
        'pass_by_reference', // <-- ADICIONAR
        'inheritance', // <-- ADICIONAR
        'method_override', // <-- ADICIONAR
        'super_keyword', // <-- ADICIONAR
        'type_cast_as_operator', // <-- ADICIONAR
        'abstract_classes', // <-- ADICIONAR
        'interfaces', // <-- ADICIONAR
        'interfaces_another_use', // <-- ADICIONAR
        'mixins', // <-- ADICIONAR
        'extension_methods',
      ],
    ),
    StudyCategory(
      title: 'Tópicos Avançados e Específicos',
      icon: Icons.auto_awesome,
      topicKeys: [
        'generics', // Já estava aqui
        'operator_overloading', // NOVO: Sobrecarga de Operadores
        'file_io', // NOVO: Manipulação de Arquivos e I/O
        'reflection_mirrors', // NOVO: Reflexão (dart:mirrors)
        'isolates_parallelism', // NOVO: Isolates para Paralelismo e Threads
        'generators', // NOVO: Geradores
        'futures_error_handling', // NOVO: Futures e Tratamento de Erros
        'streams',
      ],
    ),
    // Adicione mais categorias aqui, se tiver, usando as chaves dos seus tópicos.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias de Estudo - Dart'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ExpansionTile(
              leading:
                  Icon(category.icon, color: Colors.cyan.shade300, size: 30),
              title: Text(
                category.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: category.topicKeys.map((topicKey) {
                final topicContent =
                    getTopicContentByKey(topicKey); // Busca pelo registro

                if (topicContent == null) {
                  // Lidar com o caso onde o tópico não é encontrado
                  return ListTile(
                    title: Text(
                      'Erro: Tópico "$topicKey" não encontrado!',
                      style: TextStyle(color: Colors.red.shade300),
                    ),
                  );
                }

                return ListTile(
                  title: Text(
                    topicContent.title,
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.white54),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TopicDetailScreen(
                          topicTitle: topicContent.title,
                          codeExample: topicContent.code,
                          codeOutput: topicContent.output,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const DartPadViewScreen(), // Navega para a tela do DartPad
            ),
          );
        },
        label: const Text('Abrir DartPad'),
        icon: const Icon(Icons.code), // Ícone de código
        backgroundColor: Colors.deepPurple.shade400, // Cor de fundo
        foregroundColor: Colors.white, // Cor do texto e ícone
      ),
      // Você pode ajustar a localização do FAB com `floatingActionButtonLocation`
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
