part of '../menu_pages.dart';

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.neutral600,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: enabled ? AppColors.headerBlue : const Color(0xFFC4C7CF),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          decoration: _profileInputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  const _GenderField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gênero',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.neutral600,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: onChanged,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: Color(0xFF63D89E),
            size: 38,
          ),
          style: const TextStyle(
            color: AppColors.headerBlue,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          decoration: _profileInputDecoration(),
        ),
      ],
    );
  }
}

InputDecoration _profileInputDecoration({String? hintText}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: const Color(0xFFF0F1F4),
    hintStyle: const TextStyle(color: Color(0xFFC4C7CF), fontSize: 17),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.neutral300),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.neutral300),
    ),
  );
}
