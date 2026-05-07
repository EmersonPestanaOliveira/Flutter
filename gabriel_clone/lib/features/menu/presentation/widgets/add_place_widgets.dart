part of '../menu_pages.dart';

InputDecoration menuInputDecoration({required String hintText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: AppColors.neutral300),
    filled: true,
    fillColor: AppColors.neutral100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.headerBlue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.lg,
    ),
  );
}

Widget menuFieldLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: AppColors.headerBlue,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );
}

class MatchedPlaceCard extends StatelessWidget {
  const MatchedPlaceCard({super.key, required this.place});

  final Map<String, dynamic> place;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place['nome'] as String? ?? 'Localidade encontrada',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.headerBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(place['endereco'] as String? ?? 'Endereco nao informado'),
          ],
        ),
      ),
    );
  }
}

class AddPlaceStepHeader extends StatelessWidget {
  const AddPlaceStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral600),
        ),
      ],
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;

    final formatted = limited.length <= 5
        ? limited
        : '${limited.substring(0, 5)}-${limited.substring(5)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
