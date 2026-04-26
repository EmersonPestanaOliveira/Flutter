import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../../../core/di/theme_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../../domain/entities/app_settings.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? AppColors.dark900 : AppColors.neutral50;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Configuracoes',
          style: AppTextStyles.titleMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.neutral900,
          ),
        ),
        backgroundColor: isDark ? AppColors.dark800 : AppColors.white,
      ),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          final cubit = context.read<SettingsCubit>();
          return ListView(
            children: [

              // --- APARENCIA ---
              SettingsSection(
                title: 'Aparencia',
                children: [
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Tema',
                    subtitle: _themeLabel(settings.themeMode),
                    trailing: _ThemeSegmented(
                      current: settings.themeMode,
                      onChange: (m) {
                        cubit.setTheme(m);
                        context.read<ThemeCubit>().emit(m);
                      },
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.text_fields_rounded,
                    title: 'Escala de texto',
                    subtitle: '%',
                    trailing: SizedBox(
                      width: 160,
                      child: Slider(
                        value: settings.textScaleFactor,
                        min: 0.8,
                        max: 1.4,
                        divisions: 6,
                        label: '%',
                        onChanged: cubit.setTextScale,
                      ),
                    ),
                  ),
                ],
              ),

              // --- DESENVOLVEDOR ---
              SettingsSection(
                title: 'Desenvolvedor',
                children: [
                  SettingsTile(
                    icon: Icons.code_rounded,
                    title: 'Modo desenvolvedor',
                    subtitle: 'Ativa opcoes avancadas',
                    iconColor: AppColors.primary,
                    trailing: Switch(
                      value: settings.enableDevMode,
                      onChanged: (_) => cubit.toggleDevMode(),
                    ),
                  ),
                  if (settings.enableDevMode) ...[
                    SettingsTile(
                      icon: Icons.speed_rounded,
                      title: 'Performance overlay',
                      subtitle: 'Exibe FPS e rasterizacao',
                      trailing: Switch(
                        value: settings.showPerformanceOverlay,
                        onChanged: (_) => cubit.togglePerformanceOverlay(),
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.grid_4x4_rounded,
                      title: 'Grid overlay',
                      subtitle: 'Exibe grade de layout',
                      trailing: Switch(
                        value: settings.showGridOverlay,
                        onChanged: (_) => cubit.toggleGridOverlay(),
                      ),
                    ),
                  ],
                ],
              ),

              // --- SOBRE ---
              SettingsSection(
                title: 'App',
                children: [
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'Versao',
                    subtitle: '1.0.0 (build 1)',
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ),
                  SettingsTile(
                    icon: Icons.restore_rounded,
                    title: 'Restaurar padroes',
                    subtitle: 'Redefine todas as configuracoes',
                    iconColor: AppColors.error,
                    onTap: () => _showResetDialog(context, cubit),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          );
        },
      ),
    );
  }

  String _themeLabel(ThemeMode m) => switch (m) {
    ThemeMode.light  => 'Claro',
    ThemeMode.dark   => 'Escuro',
    ThemeMode.system => 'Sistema',
  };

  void _showResetDialog(BuildContext context, SettingsCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restaurar padroes?'),
        content: const Text('Todas as configuracoes serao redefinidas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () { cubit.reset(); Navigator.pop(context); },
            child: Text('Restaurar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// Segmented button para selecao de tema
class _ThemeSegmented extends StatelessWidget {
  const _ThemeSegmented({required this.current, required this.onChange});
  final ThemeMode current;
  final void Function(ThemeMode) onChange;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: const [
        ButtonSegment(value: ThemeMode.light,  icon: Icon(Icons.light_mode_outlined, size: 16)),
        ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto,     size: 16)),
        ButtonSegment(value: ThemeMode.dark,   icon: Icon(Icons.dark_mode_outlined,  size: 16)),
      ],
      selected: {current},
      onSelectionChanged: (s) => onChange(s.first),
    );
  }
}