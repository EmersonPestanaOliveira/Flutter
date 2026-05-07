part of '../menu_pages.dart';

class _LegalCard extends StatelessWidget {
  const _LegalCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutral0,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutral100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.headerBlue, size: 22),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.headerBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral300,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalBottomSheet extends StatelessWidget {
  const _LegalBottomSheet({required this.title, required this.contentFuture});

  final String title;
  final Future<String> contentFuture;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.4, 0.85, 0.95],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle de arrastar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Título
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.headerBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.neutral100),
              // Conteúdo rolável do banco
              Expanded(
                child: FutureBuilder<String>(
                  future: contentFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            BackendErrorMapper.message(snapshot.error!),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.neutral600,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.lg,
                        AppSpacing.xl,
                        AppSpacing.xxl,
                      ),
                      child: Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          color: AppColors.neutral800,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
