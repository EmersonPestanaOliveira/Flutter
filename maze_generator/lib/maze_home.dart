import 'dart:math';
import 'package:flutter/material.dart';
import 'maze_data.dart';
import 'maze_generator.dart';
import 'maze_painter.dart';
import 'settings_panel.dart';
import 'maze_solver.dart';

class MazeHome extends StatefulWidget {
  const MazeHome({super.key});
  @override
  State<MazeHome> createState() => _MazeHomeState();
}

class _MazeHomeState extends State<MazeHome> with TickerProviderStateMixin {
  int rows = 24;
  int cols = 42;
  int seed = DateTime.now().millisecondsSinceEpoch & 0x7fffffff;

  late MazeData maze;

  // estilo (defaults solicitados)
  double wallThickness = 2.0;
  double glowSigma = 1.0;
  final Color neon = const Color(0xFFFF2A2A);
  final Color startColor = Colors.greenAccent;
  final Color endColor = Colors.blueAccent;

  // menu
  bool showMenu = false;
  late final AnimationController _menuCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  // animação da solução (BFS/DFS/Dijkstra)
  late final AnimationController _solveCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  List<Point<int>> _path = const [];

  @override
  void initState() {
    super.initState();
    maze = MazeGenerator(rows: rows, cols: cols, seed: seed).generate();
    _solveCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _menuCtl.dispose();
    _solveCtl.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() => showMenu = !showMenu);
    if (showMenu) {
      _menuCtl.forward();
    } else {
      _menuCtl.reverse();
    }
  }

  void _clearPathAnimation() {
    _solveCtl.stop();
    _solveCtl.value = 0;
    _path = const [];
  }

  void _regenerate([int? newSeed]) {
    _clearPathAnimation();
    setState(() {
      seed = newSeed ?? seed;
      maze = MazeGenerator(rows: rows, cols: cols, seed: seed).generate();
    });
  }

  Future<void> _runBFS() async {
    final p = solveBFS(grid: maze.grid, start: maze.start, end: maze.end);
    if (p.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('BFS: nenhuma solução encontrada.')),
      );
      return;
    }
    _path = p;
    final ms = max(400, min(8000, p.length * 35));
    _solveCtl
      ..duration = Duration(milliseconds: ms)
      ..value = 0
      ..forward();
  }

  Future<void> _runDFS() async {
    final p = solveDFS(grid: maze.grid, start: maze.start, end: maze.end);
    if (p.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DFS: nenhuma solução encontrada.')),
      );
      return;
    }
    _path = p;
    final ms = max(300, min(6000, p.length * 28));
    _solveCtl
      ..duration = Duration(milliseconds: ms)
      ..value = 0
      ..forward();
  }

  Future<void> _runDijkstra() async {
    final p = solveDijkstra(grid: maze.grid, start: maze.start, end: maze.end);
    if (p.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dijkstra: nenhuma solução encontrada.')),
      );
      return;
    }
    _path = p;
    final ms = max(350, min(7000, p.length * 32));
    _solveCtl
      ..duration = Duration(milliseconds: ms)
      ..value = 0
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Canvas do labirinto
            Center(
              child: AspectRatio(
                aspectRatio: cols / rows,
                child: CustomPaint(
                  painter: MazePainter(
                    grid: maze.grid,
                    start: maze.start,
                    end: maze.end,
                    wall: wallThickness,
                    glowSigma: glowSigma,
                    color: neon,
                    startColor: startColor,
                    endColor: endColor,
                    path: _path,
                    pathT: _solveCtl.value, // 0..1 progresso
                  ),
                ),
              ),
            ),

            // Botões flutuantes: BFS, DFS, Dijkstra e Menu
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'bfs',
                    onPressed: _runBFS,
                    label: const Text(
                      'Busca em Largura (BFS)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    heroTag: 'dfs',
                    onPressed: _runDFS,
                    label: const Text(
                      'Busca em Profundidade (DFS)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    heroTag: 'dijkstra',
                    onPressed: _runDijkstra,
                    label: const Text(
                      'Dijkstra',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.small(
                    heroTag: 'menu',
                    onPressed: _toggleMenu,
                    child: Icon(showMenu ? Icons.close : Icons.tune),
                  ),
                ],
              ),
            ),

            // Painel deslizante (overlay)
            AnimatedBuilder(
              animation: _menuCtl,
              builder: (context, _) {
                final height = MediaQuery.of(context).size.height * 0.42;
                final y = -height + height * _menuCtl.value;
                return Positioned(
                  left: 0,
                  right: 0,
                  top: y,
                  child: SettingsPanel(
                    rows: rows,
                    cols: cols,
                    seed: seed,
                    wallThickness: wallThickness,
                    glowSigma: glowSigma,
                    onRows: (v) => setState(() => rows = v),
                    onCols: (v) => setState(() => cols = v),
                    onWall: (v) => setState(() => wallThickness = v),
                    onGlow: (v) => setState(() => glowSigma = v),
                    onApply: () {
                      _regenerate(seed); // aplica e fecha
                      _toggleMenu();
                    },
                    onNewSeed: () => _regenerate(Random().nextInt(0x7fffffff)),
                    onClose: _toggleMenu,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
