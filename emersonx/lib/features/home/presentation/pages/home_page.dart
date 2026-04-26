import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../../../core/di/theme_cubit.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/module_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadModules(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  int _columns(double width) {
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.sizeOf(context).width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cols   = _columns(width);

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: isDark ? AppColors.dark800 : AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                    ),
                  ),
                  Text(
                    'EmersonX',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: isDark ? AppColors.white : AppColors.neutral900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              background: Container(
                color: isDark ? AppColors.dark800 : AppColors.white,
              ),
            ),
            actions: [
              // Busca
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Buscar',
                onPressed: () => context.push(AppRoutes.search),
              ),
              // Toggle tema
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) => IconButton(
                  icon: Icon(
                    mode == ThemeMode.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  tooltip: 'Alternar tema',
                  onPressed: () => context.read<ThemeCubit>().toggle(),
                ),
              ),
              // Menu (settings + about)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (v) => context.push(v),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: AppRoutes.settings,
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Configuracoes'),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: AppRoutes.about,
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Sobre o App'),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final count = state is HomeLoaded ? state.modules.length : 0;
                  return Row(
                    children: [
                      Text(
                        'Modulos',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isDark ? AppColors.white : AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs, vertical: AppSpacing.xxxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => _ShimmerCard(isDark: isDark),
                      childCount: 8,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.85,
                    ),
                  ),
                );
              }
              if (state is HomeLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final mod = state.modules[i];
                        return ModuleCard(
                          module: mod,
                          onTap: () => context.go(mod.route),
                        );
                      },
                      childCount: state.modules.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.85,
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia, Emerson';
    if (h < 18) return 'Boa tarde, Emerson';
    return 'Boa noite, Emerson';
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard({required this.isDark});
  final bool isDark;
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: 0.4, end: 0.9).animate(_anim),
    child: Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.dark700 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
  );
}