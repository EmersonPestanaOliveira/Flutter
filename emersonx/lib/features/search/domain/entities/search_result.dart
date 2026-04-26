import 'package:flutter/material.dart';

class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.color,
    this.breadcrumb = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color color;
  final String breadcrumb;

  // Calcula score de similaridade com a query (0.0 a 1.0)
  double score(String query) {
    if (query.isEmpty) return 0;
    final q = query.toLowerCase().trim();
    final t = title.toLowerCase();
    final s = subtitle.toLowerCase();
    if (t == q) return 1.0;
    if (t.startsWith(q)) return 0.9;
    if (t.contains(q)) return 0.8;
    if (s.contains(q)) return 0.6;
    // Busca por palavras individuais
    final words = q.split(' ').where((w) => w.isNotEmpty);
    final matches = words.where((w) => t.contains(w) || s.contains(w)).length;
    if (words.isEmpty) return 0;
    return matches / words.length * 0.5;
  }
}