import 'dart:math' as _math;

import 'package:flutter/material.dart';
import 'package:spirograph_generator/epicycles_tab.dart';
import 'package:spirograph_generator/rolling_wheels_tab.dart';
import 'package:spirograph_generator/background_style.dart';
import 'package:spirograph_generator/color_picker_sheet.dart';

void main() => runApp(const SpirographApp());

class SpirographApp extends StatelessWidget {
  const SpirographApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // DEFAULT preservado: Original
  BackgroundConfig _bg = const BackgroundConfig.original();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickCustomColor() async {
    // cor base sugerida quando entrar no picker
    final base = switch (_bg.mode) {
      BackgroundMode.custom => _bg.color ?? const Color(0xFF1A1A22),
      BackgroundMode.original => const Color(0xFF1A1A22),
    };

    final selected = await showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.9,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: ColorPickerSheet(initial: base),
          );
        },
      ),
    );

    if (selected != null) {
      setState(() => _bg = BackgroundConfig.custom(selected));
    }
  }

  void _resetToDefault() =>
      setState(() => _bg = const BackgroundConfig.original());

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spirograph Generator'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Cor de fundo',
            icon: const Icon(Icons.color_lens),
            onSelected: (v) {
              switch (v) {
                case 'custom':
                  _pickCustomColor();
                  break;
                case 'reset':
                  _resetToDefault();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'custom',
                child: Row(
                  children: [
                    const Icon(Icons.tune, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _bg.mode == BackgroundMode.custom
                          ? 'Editar cor de fundo'
                          : 'Escolher cor de fundo',
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: const [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Voltar cor de fundo padrão'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Rodas rolando'),
            Tab(text: 'Epiciclos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RollingWheelsTab(background: _bg),
          EpicyclesTab(background: _bg),
        ],
      ),
    );
  }
}

// Pequenas helpers trig sem importar dart:math em todo o arquivo
const double _pi = 3.1415926535897932;

double cos(double x) => Math.cos(x);
double sin(double x) => Math.sin(x);

/// Wrapper leve para trig — centraliza import aqui
class Math {
  static const double pi = _pi;
  static double cos(double x) => _math.cos(x);
  static double sin(double x) => _math.sin(x);
}
