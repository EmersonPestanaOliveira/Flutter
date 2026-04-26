import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/search_result.dart';
import '../../data/datasources/search_index.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchIdle());

  // Historico em memoria (max 8 itens)
  final List<SearchResult> _history = [];
  List<SearchResult> get history => List.unmodifiable(_history);

  void search(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      emit(const SearchIdle());
      return;
    }

    // Filtra e ordena pelo score
    final results = SearchIndex.all
        .map((r) => _ScoredResult(r, r.score(q)))
        .where((s) => s.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final found = results.map((s) => s.result).toList();
    emit(SearchResults(query: q, results: found));
  }

  void clear() => emit(const SearchIdle());

  void addToHistory(SearchResult result) {
    _history.removeWhere((r) => r.id == result.id);
    _history.insert(0, result);
    if (_history.length > 8) _history.removeLast();
    // Re-emite o estado atual com historico atualizado
    final current = state;
    if (current is SearchIdle) emit(const SearchIdle());
  }

  void removeFromHistory(String id) {
    _history.removeWhere((r) => r.id == id);
    emit(const SearchIdle());
  }
}

class _ScoredResult {
  const _ScoredResult(this.result, this.score);
  final SearchResult result;
  final double score;
}