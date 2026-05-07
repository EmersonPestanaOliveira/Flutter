import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_notifier.dart';
import '../../data/services/placas_service.dart';

class PlacasFormScreen extends StatefulWidget {
  const PlacasFormScreen({super.key});

  @override
  State<PlacasFormScreen> createState() => _PlacasFormScreenState();
}

class _PlacasFormScreenState extends State<PlacasFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PlacasService();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _numeroController = TextEditingController();

  String? _perfilContato;
  String? _jaFazParteLocalidade;
  String? _melhorHorarioContato;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _enderecoController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.brandGreen,
            size: 36,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Quero contratar',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo_vazado.webp',
                        width: 210,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text(
                              'Gabriel',
                              style: TextStyle(
                                color: AppColors.headerBlue,
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      'Estamos muito felizes com o seu interesse!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.headerBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const Text(
                      'Em breve um dos nossos atendentes entrará em contato :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.headerBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _ProfileLikeTextField(
                      controller: _nomeController,
                      label: 'Nome',
                      hintText: 'Qual o seu nome?',
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _sobrenomeController,
                      label: 'Sobrenome',
                      hintText: 'Qual o seu sobrenome?',
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      hintText: 'Qual o seu endereço de e-mail?',
                      keyboardType: TextInputType.emailAddress,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _telefoneController,
                      label: 'Número de telefone com DDD',
                      hintText: '+55 (11) 99999-9999',
                      keyboardType: TextInputType.phone,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeDropdown(
                      label: 'Perfil do contato',
                      value: _perfilContato,
                      hintText: 'Qual o seu perfil?',
                      options: const [
                        'Morador',
                        'Síndico',
                        'Administrador',
                        'Comerciante',
                        'Outro',
                      ],
                      validator: _requiredText,
                      onChanged: (value) =>
                          setState(() => _perfilContato = value),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _cepController,
                      label: 'CEP',
                      hintText: '00000-000',
                      keyboardType: TextInputType.number,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _enderecoController,
                      label: 'Endereço',
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeTextField(
                      controller: _numeroController,
                      label: 'Nº do endereço',
                      keyboardType: TextInputType.number,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProfileLikeDropdown(
                      label: 'Já faz parte de uma localidade com Gabriel?',
                      value: _jaFazParteLocalidade,
                      hintText: 'Selecione',
                      options: const ['Sim', 'Não', 'Não sei informar'],
                      validator: _requiredText,
                      onChanged: (value) =>
                          setState(() => _jaFazParteLocalidade = value),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _ProfileLikeLabel(
                      'Melhor horário para entrarmos em contato por ligação',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _RadioOption(
                      value: 'Manhã (09:00 às 12:00)',
                      groupValue: _melhorHorarioContato,
                      onChanged: (value) =>
                          setState(() => _melhorHorarioContato = value),
                    ),
                    _RadioOption(
                      value: 'Tarde (13:00 às 17:00)',
                      groupValue: _melhorHorarioContato,
                      onChanged: (value) =>
                          setState(() => _melhorHorarioContato = value),
                    ),
                    _RadioOption(
                      value: 'Noite (18:00 às 20:00)',
                      groupValue: _melhorHorarioContato,
                      onChanged: (value) =>
                          setState(() => _melhorHorarioContato = value),
                    ),
                    _RadioOption(
                      value: 'Prefiro contato por WhatsApp',
                      groupValue: _melhorHorarioContato,
                      onChanged: (value) =>
                          setState(() => _melhorHorarioContato = value),
                    ),
                    const SizedBox(height: 56),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: const Color(0xFF00C982),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.neutral0,
                              ),
                            )
                          : const Text(
                              'Enviar',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_melhorHorarioContato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o melhor horário de contato.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _service.createSolicitacao(
        PlacasSolicitacaoInput(
          nome: _nomeController.text.trim(),
          sobrenome: _sobrenomeController.text.trim(),
          email: _emailController.text.trim(),
          telefone: _telefoneController.text.trim(),
          perfilContato: _perfilContato!,
          cep: _cepController.text.trim(),
          endereco: _enderecoController.text.trim(),
          numeroEndereco: _numeroController.text.trim(),
          jaFazParteLocalidade: _jaFazParteLocalidade!,
          melhorHorarioContato: _melhorHorarioContato!,
        ),
      );

      if (mounted) {
        context.go(AppRoutes.placasSuccess);
      }
    } catch (error) {
      if (mounted) {
        AppErrorNotifier.show(context, error);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _ProfileLikeTextField extends StatelessWidget {
  const _ProfileLikeTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileLikeLabel(label, required: validator != null),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: AppColors.headerBlue,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          decoration: _profileInputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}

class _ProfileLikeDropdown extends StatelessWidget {
  const _ProfileLikeDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
    this.validator,
  });

  final String label;
  final String? value;
  final String? hintText;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileLikeLabel(label, required: validator != null),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: hintText == null ? null : Text(hintText!),
          validator: validator,
          isExpanded: true,
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

class _ProfileLikeLabel extends StatelessWidget {
  const _ProfileLikeLabel(this.label, {this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppColors.neutral600,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.accentRed),
            ),
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00C982)
                      : AppColors.neutral300,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: isSelected ? 12 : 0,
                  height: isSelected ? 12 : 0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C982),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.headerBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
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
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accentRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accentRed),
    ),
  );
}

String? _requiredText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Preencha este campo.';
  }
  return null;
}
