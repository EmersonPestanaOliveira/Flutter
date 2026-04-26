import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [Color(0xFF0F2A44), Color(0xFF0A1724)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo do Project Smith (SVG)
              SvgPicture.asset(
                'assets/images/project-smith-logo.svg',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 12),
              Text(
                'Project Smith',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.widgets_outlined),
                        title: const Text('Página Material'),
                        subtitle: const Text('Catálogo de widgets e exemplos'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(context, '/material'),
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Tema escuro'),
                        value: isDark,
                        onChanged: (_) => onToggleTheme(),
                        secondary: const Icon(Icons.brightness_6_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('v0.1 • demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
