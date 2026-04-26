import 'dart:math';

import 'package:maze_generator/cell.dart';

class MazeData {
  final List<List<Cell>> grid;
  final Point<int> start; // entrada
  final Point<int> end; // saída
  MazeData(this.grid, this.start, this.end);
}
