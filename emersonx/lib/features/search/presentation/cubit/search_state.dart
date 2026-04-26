import '../../domain/entities/search_result.dart';

abstract class SearchState {
  const SearchState();
}

class SearchIdle extends SearchState {
  const SearchIdle();
}

class SearchResults extends SearchState {
  const SearchResults({required this.query, required this.results});
  final String query;
  final List<SearchResult> results;
  bool get isEmpty => results.isEmpty;
}