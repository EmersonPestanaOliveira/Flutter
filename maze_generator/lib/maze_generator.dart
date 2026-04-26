import 'dart:math';

import 'package:maze_generator/cell.dart';
import 'package:maze_generator/maze_data.dart';

class MazeGenerator {
  final int rows, cols, seed;
  MazeGenerator({required this.rows, required this.cols, required this.seed});

  MazeData generate() {
    final grid = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
    final rand = Random(seed);

    // Iterative DFS (recursive backtracker)
    final stack = <Point<int>>[];
    var current = Point(rand.nextInt(rows), rand.nextInt(cols));
    grid[current.x][current.y].visited = true;

    do {
      final neighbors = _unvisitedNeighbors(grid, current);
      if (neighbors.isNotEmpty) {
        final next = neighbors[rand.nextInt(neighbors.length)];
        _removeWall(grid, current, next);
        stack.add(current);
        current = next;
        grid[current.x][current.y].visited = true;
      } else if (stack.isNotEmpty) {
        current = stack.removeLast();
      }
    } while (stack.isNotEmpty || _hasUnvisited(grid));

    // Define entrada (coluna 0) e saída (última coluna) e abre passagens
    final startRow = rand.nextInt(rows);
    final endRow = rand.nextInt(rows);
    grid[startRow][0].left = false; // abre na borda esquerda
    grid[endRow][cols - 1].right = false; // abre na borda direita
    final start = Point(startRow, 0);
    final end = Point(endRow, cols - 1);

    return MazeData(grid, start, end);
  }

  bool _hasUnvisited(List<List<Cell>> g) {
    for (final row in g) {
      for (final c in row) {
        if (!c.visited) return true;
      }
    }
    return false;
  }

  List<Point<int>> _unvisitedNeighbors(List<List<Cell>> g, Point<int> p) {
    final out = <Point<int>>[];
    if (p.x > 0 && !g[p.x - 1][p.y].visited) out.add(Point(p.x - 1, p.y));
    if (p.y < cols - 1 && !g[p.x][p.y + 1].visited)
      out.add(Point(p.x, p.y + 1));
    if (p.x < rows - 1 && !g[p.x + 1][p.y].visited)
      out.add(Point(p.x + 1, p.y));
    if (p.y > 0 && !g[p.x][p.y - 1].visited) out.add(Point(p.x, p.y - 1));
    return out;
  }

  void _removeWall(List<List<Cell>> g, Point<int> a, Point<int> b) {
    if (a.x == b.x && a.y == b.y + 1) {
      // a is right of b -> remove a.left & b.right
      g[a.x][a.y].left = false;
      g[b.x][b.y].right = false;
    } else if (a.x == b.x && a.y + 1 == b.y) {
      g[a.x][a.y].right = false;
      g[b.x][b.y].left = false;
    } else if (a.y == b.y && a.x + 1 == b.x) {
      g[a.x][a.y].bottom = false;
      g[b.x][b.y].top = false;
    } else if (a.y == b.y && a.x == b.x + 1) {
      g[a.x][a.y].top = false;
      g[b.x][b.y].bottom = false;
    }
  }
}
