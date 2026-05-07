import '../../domain/entities/resultado.dart';

sealed class ResultadosState {
  const ResultadosState();
}

class ResultadosInitial extends ResultadosState {
  const ResultadosInitial();
}

class ResultadosLoading extends ResultadosState {
  const ResultadosLoading();
}

class ResultadosLoaded extends ResultadosState {
  const ResultadosLoaded({
    required this.todos,
    required this.filtro,
    required this.query,
  });

  final List<Resultado> todos;

  /// 'casos_solucionados' | 'novidades'
  final String filtro;
  final String query;

  List<Resultado> get filtrados {
    return todos.where((r) {
      final matchesFiltro = r.categoria == filtro;
      final q = query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          r.titulo.toLowerCase().contains(q) ||
          r.cidade.toLowerCase().contains(q);
      return matchesFiltro && matchesQuery;
    }).toList();
  }

  ResultadosLoaded copyWith({String? filtro, String? query}) {
    return ResultadosLoaded(
      todos: todos,
      filtro: filtro ?? this.filtro,
      query: query ?? this.query,
    );
  }
}

class ResultadosError extends ResultadosState {
  const ResultadosError({required this.message});
  final String message;
}
