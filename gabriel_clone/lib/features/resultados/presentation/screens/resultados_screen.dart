import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/resultado.dart';
import '../cubit/resultados_cubit.dart';
import '../cubit/resultados_state.dart';

/// Tag Hero compartilhado com o bottom nav.
const _kHeroTag = 'resultados-label';

class ResultadosScreen extends StatelessWidget {
  const ResultadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResultadosCubit()..loadResultados(),
      child: const _ResultadosView(),
    );
  }
}

// ─────────────────────────────────────────────
// View
// ─────────────────────────────────────────────
class _ResultadosView extends StatefulWidget {
  const _ResultadosView();

  @override
  State<_ResultadosView> createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<_ResultadosView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _SearchBar(controller: _searchController),
            const SizedBox(height: AppSpacing.sm),
            const _FilterRow(),
            const SizedBox(height: AppSpacing.lg),
            const Expanded(child: _ResultadosList()),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutral0,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: AppColors.brandGreen,
          size: 34,
        ),
        onPressed: () => context.go(AppRoutes.home),
      ),
      title: Hero(
        tag: _kHeroTag,
        flightShuttleBuilder: (_, animation, _, fromCtx, toCtx) {
          return FadeTransition(opacity: animation, child: toCtx.widget);
        },
        child: Material(
          color: Colors.transparent,
          child: Text(
            'Resultados',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.headerBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Pesquise por casos e notícias',
          hintStyle: const TextStyle(color: AppColors.neutral300, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.neutral300),
          filled: true,
          fillColor: AppColors.neutral0,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.neutral100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.neutral100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.brandGreen,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (v) => context.read<ResultadosCubit>().buscar(v),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter row
// ─────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultadosCubit, ResultadosState>(
      builder: (context, state) {
        if (state is! ResultadosLoaded) return const SizedBox.shrink();
        final cubit = context.read<ResultadosCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: _FilterChip(
                  label: 'Casos Solucionados',
                  isActive: state.filtro == 'casos_solucionados',
                  onTap: () => cubit.filtrar('casos_solucionados'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _FilterChip(
                  label: 'Novidades',
                  isActive: state.filtro == 'novidades',
                  onTap: () => cubit.filtrar('novidades'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandGreen : AppColors.neutral0,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.brandGreen, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.neutral0 : AppColors.brandGreen,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Lista de resultados
// ─────────────────────────────────────────────
class _ResultadosList extends StatelessWidget {
  const _ResultadosList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultadosCubit, ResultadosState>(
      builder: (context, state) {
        if (state is ResultadosInitial || state is ResultadosLoading) {
          return const AppLoadingIndicator();
        }

        if (state is ResultadosError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.neutral300,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.neutral600,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () =>
                        context.read<ResultadosCubit>().loadResultados(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! ResultadosLoaded) return const SizedBox.shrink();

        final items = state.filtrados;

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_off,
                  color: AppColors.neutral300,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nenhum resultado encontrado.',
                  style: TextStyle(color: AppColors.neutral600, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
          itemBuilder: (_, index) => _ResultadoCard(resultado: items[index]),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Card de resultado
// ─────────────────────────────────────────────
class _ResultadoCard extends StatelessWidget {
  const _ResultadoCard({required this.resultado});

  final Resultado resultado;

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  Future<void> _share(BuildContext context) async {
    final categoria = resultado.isNovidade ? 'Novidade' : 'Caso Solucionado';
    final buffer = StringBuffer();

    buffer.writeln('[$categoria] ${resultado.titulo}');

    if (resultado.cidade.isNotEmpty) {
      buffer.writeln('📍 ${resultado.cidade}');
    }

    buffer.writeln('📅 ${_formatDate(resultado.data)}');

    if (resultado.conteudo != null && resultado.conteudo!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(resultado.conteudo);
    }

    if (resultado.imagemUrl != null && resultado.imagemUrl!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(resultado.imagemUrl);
    }

    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      buffer.toString().trim(),
      subject: resultado.titulo,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNovidade = resultado.isNovidade;

    return Container(
      decoration: BoxDecoration(
        color: isNovidade ? AppColors.brandGreen : AppColors.neutral0,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resultado.imagemUrl != null && resultado.imagemUrl!.isNotEmpty)
            _CardImage(url: resultado.imagemUrl!, isNovidade: isNovidade),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resultado.titulo,
                        style: const TextStyle(
                          color: AppColors.headerBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        resultado.cidade,
                        style: const TextStyle(
                          color: AppColors.neutral600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _formatDate(resultado.data),
                        style: const TextStyle(
                          color: AppColors.neutral600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.ios_share,
                    color: AppColors.headerBlue,
                    size: 22,
                  ),
                  onPressed: () => _share(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.url, required this.isNovidade});

  final String url;
  final bool isNovidade;

  @override
  Widget build(BuildContext context) {
    final safeUrl = Uri.encodeFull(url.trim());
    final image = Image.network(
      safeUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 200,
          color: AppColors.neutral100,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.brandGreen,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (_, _, _) => Container(
        color: AppColors.neutral100,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.neutral300,
            size: 34,
          ),
        ),
      ),
    );

    if (isNovidade) {
      // Novidades: imagem com padding dentro do card verde, bordas arredondadas
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(aspectRatio: 16 / 9, child: image),
        ),
      );
    }

    // Casos Solucionados: imagem ocupa toda a largura do card
    return AspectRatio(aspectRatio: 16 / 9, child: image);
  }
}
