// lib/data/study_data_models.dart

import 'package:flutter/material.dart'; // Necessário para IconData

// Definição da estrutura de um tópico com código e saída
class TopicContent {
  final String code;
  final String output;
  final String description;
  final String title; // Adicione um título explícito para exibição

  TopicContent(
      {required this.code,
      required this.output,
      required this.title,
      this.description = ''});
}

// Definição da estrutura de uma categoria
class StudyCategory {
  final String title;
  final List<String> topicKeys; // Agora guarda apenas as chaves dos tópicos
  final IconData icon;

  StudyCategory(
      {required this.title, required this.topicKeys, required this.icon});
}
