import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_result_tile.dart';
import '../../domain/entities/search_result.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();
  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Abre o teclado automaticamente
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SearchCubit>().search(value);
  }

  void _onSelect(BuildContext context, SearchResult result) {
    context.read<SearchCubit>().addToHistory(result);
    context.go(result.route);
  }

  void _onClear(BuildContext context) {
    _controller.clear();
    context.read<SearchCubit>().clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final bgColor = isDark ? AppColors.dark800 : AppColors.white;
    final fieldBg = isDark ? AppColors.dark700 : AppColors.neutral100;
    final hintColor = isDark ? AppColors.neutral400 : AppColors.neutral600;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark900 : AppColors.neutral50,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de busca no topo
            Container(
              color: bgColor,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm,
                AppSpacing.md, AppSpacing.md,
              ),
              child: Row(
                children: [
                  // Botao voltar
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: isDark ? AppColors.white : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Campo de texto
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: fieldBg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppSpacing.md),
                          Icon(Icons.search_rounded, size: 20, color: hintColor),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focus,
                              onChanged: (v) => _onChanged(context, v),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.white : AppColors.neutral900,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Buscar modulos e telas...',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: hintColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          // Botao limpar
                          BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                              if (state is! SearchResults) {
                                return const SizedBox(width: AppSpacing.md);
                              }
                              return GestureDetector(
                                onTap: () => _onClear(context),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: hintColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conteudo
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final cubit = context.read<SearchCubit>();

                  // Estado inicial: mostrar historico
                  if (state is SearchIdle) {
                    if (cubit.history.isEmpty) {
                      return _EmptyHint(isDark: isDark);
                    }
                    return _HistoryList(
                      history: cubit.history,
                      isDark: isDark,
                      onTap: (r) => _onSelect(context, r),
                      onRemove: (id) => cubit.removeFromHistory(id),
                    );
                  }

                  // Sem resultados
                  if (state is SearchResults && state.isEmpty) {
                    return _NoResults(query: state.query, isDark: isDark);
                  }

                  // Lista de resultados
                  if (state is SearchResults) {
                    return _ResultsList(
                      results: state.results,
                      query: state.query,
                      isDark: isDark,
                      bgColor: bgColor,
                      onTap: (r) => _onSelect(context, r),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Widgets internos ----

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: isDark ? AppColors.dark600 : AppColors.neutral200,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Digite para buscar modulos',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query, required this.isDark});
  final String query;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: isDark ? AppColors.dark600 : AppColors.neutral200,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nada encontrado para',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '"$query"',
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.query,
    required this.isDark,
    required this.bgColor,
    required this.onTap,
  });
  final List<SearchResult> results;
  final String query;
  final bool isDark;
  final Color bgColor;
  final void Function(SearchResult) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, 0, AppSpacing.xs),
          child: Text(
            ' resultado',
            style: AppTextStyles.labelSmall.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: bgColor,
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 72,
                color: isDark ? AppColors.dark600 : AppColors.neutral200,
              ),
              itemBuilder: (context, i) => SearchResultTile(
                result: results[i],
                query: query,
                onTap: () => onTap(results[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.history,
    required this.isDark,
    required this.onTap,
    required this.onRemove,
  });
  final List<SearchResult> history;
  final bool isDark;
  final void Function(SearchResult) onTap;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.dark800 : AppColors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, 0, AppSpacing.xs),
          child: Text(
            'Recentes',
            style: AppTextStyles.labelSmall.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: bgColor,
            child: ListView.separated(
              itemCount: history.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 72,
                color: isDark ? AppColors.dark600 : AppColors.neutral200,
              ),
              itemBuilder: (context, i) {
                final r = history[i];
                return Dismissible(
                  key: ValueKey(r.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: AppColors.error.withOpacity(0.1),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: const Icon(Icons.delete_outline, color: AppColors.error),
                  ),
                  onDismissed: (_) => onRemove(r.id),
                  child: SearchResultTile(
                    result: r,
                    query: '',
                    onTap: () => onTap(r),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}