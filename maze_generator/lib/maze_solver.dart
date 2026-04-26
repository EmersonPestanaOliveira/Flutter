import 'dart:collection';
import 'dart:math';
import 'cell.dart';

/// Retorna o menor caminho (lista de células) de start -> end usando BFS.
/// Cada Point<int> é (row, col).
List<Point<int>> solveBFS({
  required List<List<Cell>> grid,
  required Point<int> start,
  required Point<int> end,
}) {
  final rows = grid.length;
  final cols = grid.first.length;

  bool inBounds(int r, int c) => r >= 0 && r < rows && c >= 0 && c < cols;

  bool canMove(Point<int> a, Point<int> b) {
    // Mesma linha/coluna e adjacentes
    if (a.x == b.x && a.y + 1 == b.y) {
      return !grid[a.x][a.y].right && !grid[b.x][b.y].left;
    } else if (a.x == b.x && a.y == b.y + 1) {
      return !grid[a.x][a.y].left && !grid[b.x][b.y].right;
    } else if (a.y == b.y && a.x + 1 == b.x) {
      return !grid[a.x][a.y].bottom && !grid[b.x][b.y].top;
    } else if (a.y == b.y && a.x == b.x + 1) {
      return !grid[a.x][a.y].top && !grid[b.x][b.y].bottom;
    }
    return false;
  }

  final q = Queue<Point<int>>();
  final visited = List.generate(rows, (_) => List.filled(cols, false));
  final parent = List.generate(
    rows,
    (_) => List<Point<int>?>.filled(cols, null, growable: false),
  );

  q.add(start);
  visited[start.x][start.y] = true;

  while (q.isNotEmpty) {
    final cur = q.removeFirst();
    if (cur == end) break;

    const ds = [Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)];
    for (final d in ds) {
      final nr = cur.x + d.x;
      final nc = cur.y + d.y;
      if (!inBounds(nr, nc)) continue;
      final nxt = Point(nr, nc);
      if (visited[nr][nc]) continue;
      if (!canMove(cur, nxt)) continue;

      visited[nr][nc] = true;
      parent[nr][nc] = cur;
      q.add(nxt);
    }
  }

  // Reconstrói caminho
  final path = <Point<int>>[];
  Point<int>? cur = end;
  if (parent[cur.x][cur.y] == null && cur != start) {
    return path; // sem solução
  }
  while (cur != null) {
    path.add(cur);
    if (cur == start) break;
    cur = parent[cur.x][cur.y];
  }
  return path.reversed.toList();
}

/// Novo: caminho usando DFS (não garante menor caminho).
List<Point<int>> solveDFS({
  required List<List<Cell>> grid,
  required Point<int> start,
  required Point<int> end,
}) {
  final rows = grid.length;
  final cols = grid.first.length;

  bool inBounds(int r, int c) => r >= 0 && r < rows && c >= 0 && c < cols;

  bool canMove(Point<int> a, Point<int> b) {
    if (a.x == b.x && a.y + 1 == b.y) {
      return !grid[a.x][a.y].right && !grid[b.x][b.y].left;
    } else if (a.x == b.x && a.y == b.y + 1) {
      return !grid[a.x][a.y].left && !grid[b.x][b.y].right;
    } else if (a.y == b.y && a.x + 1 == b.x) {
      return !grid[a.x][a.y].bottom && !grid[b.x][b.y].top;
    } else if (a.y == b.y && a.x == b.x + 1) {
      return !grid[a.x][a.y].top && !grid[b.x][b.y].bottom;
    }
    return false;
  }

  final visited = List.generate(rows, (_) => List.filled(cols, false));
  final parent = List.generate(
    rows,
    (_) => List<Point<int>?>.filled(cols, null, growable: false),
  );

  // Pilha LIFO
  final stack = <Point<int>>[];
  stack.add(start);
  visited[start.x][start.y] = true;

  while (stack.isNotEmpty) {
    final cur = stack.removeLast();
    if (cur == end) break;

    // ordem de vizinhos: cima, direita, baixo, esquerda (padrão)
    const ds = [Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)];
    for (final d in ds) {
      final nr = cur.x + d.x;
      final nc = cur.y + d.y;
      if (!inBounds(nr, nc)) continue;
      if (visited[nr][nc]) continue;

      final nxt = Point(nr, nc);
      if (!canMove(cur, nxt)) continue;

      visited[nr][nc] = true;
      parent[nr][nc] = cur;
      stack.add(nxt);
    }
  }

  // Reconstrução do caminho
  final path = <Point<int>>[];
  Point<int>? cur = end;
  if (parent[cur.x][cur.y] == null && cur != start) {
    return path; // sem solução
  }
  while (cur != null) {
    path.add(cur);
    if (cur == start) break;
    cur = parent[cur.x][cur.y];
  }
  return path.reversed.toList();
}

List<Point<int>> solveDijkstra({
  required List<List<Cell>> grid,
  required Point<int> start,
  required Point<int> end,
}) {
  final rows = grid.length;
  final cols = grid.first.length;

  bool inBounds(int r, int c) => r >= 0 && r < rows && c >= 0 && c < cols;

  bool canMove(Point<int> a, Point<int> b) {
    if (a.x == b.x && a.y + 1 == b.y) {
      return !grid[a.x][a.y].right && !grid[b.x][b.y].left;
    } else if (a.x == b.x && a.y == b.y + 1) {
      return !grid[a.x][a.y].left && !grid[b.x][b.y].right;
    } else if (a.y == b.y && a.x + 1 == b.x) {
      return !grid[a.x][a.y].bottom && !grid[b.x][b.y].top;
    } else if (a.y == b.y && a.x == b.x + 1) {
      return !grid[a.x][a.y].top && !grid[b.x][b.y].bottom;
    }
    return false;
  }

  // Distância e pai
  const INF = 1 << 30;
  final dist = List.generate(
    rows,
    (_) => List<int>.filled(cols, INF, growable: false),
  );
  final parent = List.generate(
    rows,
    (_) => List<Point<int>?>.filled(cols, null, growable: false),
  );

  dist[start.x][start.y] = 0;

  // “Fila de prioridade” simples: lista + extração do mínimo
  // (suficiente para tamanhos moderados; substitua por um heap se precisar)
  final open = <Point<int>>[start];
  final inOpen = List.generate(rows, (_) => List<bool>.filled(cols, false));
  inOpen[start.x][start.y] = true;

  const dirs = [Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)];

  while (open.isNotEmpty) {
    // extrai nó com menor distância
    var bestIdx = 0;
    var best = open[0];
    for (var i = 1; i < open.length; i++) {
      final p = open[i];
      if (dist[p.x][p.y] < dist[best.x][best.y]) {
        best = p;
        bestIdx = i;
      }
    }
    final u = best;
    open.removeAt(bestIdx);
    inOpen[u.x][u.y] = false;

    if (u == end) break; // já encontrou a melhor distância para o destino

    for (final d in dirs) {
      final nr = u.x + d.x;
      final nc = u.y + d.y;
      if (!inBounds(nr, nc)) continue;
      final v = Point(nr, nc);
      if (!canMove(u, v)) continue;

      final alt = dist[u.x][u.y] + 1; // custo uniforme
      if (alt < dist[nr][nc]) {
        dist[nr][nc] = alt;
        parent[nr][nc] = u;
        if (!inOpen[nr][nc]) {
          open.add(v);
          inOpen[nr][nc] = true;
        }
      }
    }
  }

  // Reconstrói caminho
  final path = <Point<int>>[];
  if (dist[end.x][end.y] == INF) return path; // sem solução

  Point<int>? cur = end;
  while (cur != null) {
    path.add(cur);
    if (cur == start) break;
    cur = parent[cur.x][cur.y];
  }
  return path.reversed.toList();
}
