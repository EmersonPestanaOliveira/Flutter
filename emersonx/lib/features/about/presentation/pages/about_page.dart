import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../widgets/tech_badge.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final bgCard = isDark ? AppColors.dark800 : AppColors.white;
    final border = isDark ? AppColors.dark600 : AppColors.neutral200;
    final textPrimary = isDark ? AppColors.white : AppColors.neutral900;
    final textMuted = isDark ? AppColors.neutral400 : AppColors.neutral600;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark900 : AppColors.neutral50,
      appBar: AppBar(
        title: Text(
          'Sobre o App',
          style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
        ),
        backgroundColor: isDark ? AppColors.dark800 : AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [

          // --- Hero card ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: bgCard,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: scheme.primary.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(44, 44),
                      painter: _MiniLogoPainter(color: scheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'EmersonX',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Flutter Portfolio App',
                  style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Versao - tap para copiar
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: '1.0.0+1'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Versao copiada!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      'v1.0.0 (build 1)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // --- Desenvolvedor ---
          _InfoCard(
            title: 'Desenvolvedor',
            icon: Icons.person_outline,
            isDark: isDark,
            bgCard: bgCard,
            border: border,
            children: [
              _InfoRow(label: 'Nome',  value: 'Emerson',           isDark: isDark),
              _InfoRow(label: 'Stack', value: 'Flutter / Dart',    isDark: isDark),
              _InfoRow(label: 'Foco',  value: 'Mobile & Frontend', isDark: isDark),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // --- Arquitetura ---
          _InfoCard(
            title: 'Arquitetura',
            icon: Icons.architecture,
            isDark: isDark,
            bgCard: bgCard,
            border: border,
            children: [
              _InfoRow(label: 'Padrao',  value: 'Microapps + Clean Architecture', isDark: isDark),
              _InfoRow(label: 'DI',      value: 'get_it + injectable',            isDark: isDark),
              _InfoRow(label: 'Estado',  value: 'flutter_bloc + Cubit',           isDark: isDark),
              _InfoRow(label: 'Rotas',   value: 'go_router',                     isDark: isDark),
              _InfoRow(label: 'Backend', value: 'Firebase + REST APIs',           isDark: isDark),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // --- Stack de tecnologias ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: bgCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.layers_outlined, size: 18, color: textMuted),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Stack de Tecnologias',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: textPrimary, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    TechBadge(label: 'Flutter 3.x',        color: AppColors.moduleConnectivity),
                    TechBadge(label: 'Dart 3.x',           color: AppColors.moduleConnectivity),
                    TechBadge(label: 'flutter_bloc',       color: AppColors.moduleDesignSystem),
                    TechBadge(label: 'go_router',          color: AppColors.moduleRouting),
                    TechBadge(label: 'get_it',             color: AppColors.moduleDI),
                    TechBadge(label: 'Firebase',           color: AppColors.moduleAnimations),
                    TechBadge(label: 'Google Maps',        color: AppColors.moduleMaps),
                    TechBadge(label: 'Gemini AI',          color: AppColors.moduleAI),
                    TechBadge(label: 'Hive',               color: AppColors.moduleRegional),
                    TechBadge(label: 'fpdart',             color: AppColors.moduleSensors),
                    TechBadge(label: 'Rive',               color: AppColors.moduleAnimations),
                    TechBadge(label: 'Lottie',             color: AppColors.moduleAnimations),
                    TechBadge(label: 'mocktail',           color: AppColors.moduleTesting),
                    TechBadge(label: 'bloc_test',          color: AppColors.moduleTesting),
                    TechBadge(label: 'SOLID',              color: AppColors.success),
                    TechBadge(label: 'Material 3',         color: AppColors.moduleSocial),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // --- Modulos ---
          _InfoCard(
            title: 'Modulos',
            icon: Icons.grid_view_rounded,
            isDark: isDark,
            bgCard: bgCard,
            border: border,
            children: [
              _InfoRow(label: 'Total',        value: '14 modulos',      isDark: isDark),
              _InfoRow(label: 'Telas',        value: '68+ telas',       isDark: isDark),
              _InfoRow(label: 'Componentes',  value: 'Design System',   isDark: isDark),
              _InfoRow(label: 'Cobertura',    value: 'Testes unitarios',isDark: isDark),
            ],
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Rodape
          Center(
            child: Text(
              'Feito com Flutter por Emerson',
              style: AppTextStyles.labelSmall.copyWith(color: textMuted),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.bgCard,
    required this.border,
    required this.children,
  });
  final String title;
  final IconData icon;
  final bool isDark;
  final Color bgCard;
  final Color border;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.white : AppColors.neutral900;
    final textMuted   = isDark ? AppColors.neutral400 : AppColors.neutral600;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: textMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: textPrimary, fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children.indexed.map((e) {
            final i = e.;
            final w = e.;
            return Column(
              children: [
                if (i > 0) Divider(height: 1, color: border),
                w,
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
  });
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.neutral900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLogoPainter extends CustomPainter {
  const _MiniLogoPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final w = size.width;
    final h = size.height;
    final e = Path()
      ..moveTo(w * 0.05, h * 0.1)..lineTo(w * 0.05, h * 0.9)
      ..moveTo(w * 0.05, h * 0.1)..lineTo(w * 0.38, h * 0.1)
      ..moveTo(w * 0.05, h * 0.5)..lineTo(w * 0.32, h * 0.5)
      ..moveTo(w * 0.05, h * 0.9)..lineTo(w * 0.38, h * 0.9);
    canvas.drawPath(e, p);
    canvas.drawLine(Offset(w * 0.52, h * 0.1), Offset(w * 0.95, h * 0.9), p);
    canvas.drawLine(Offset(w * 0.95, h * 0.1), Offset(w * 0.52, h * 0.9), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}