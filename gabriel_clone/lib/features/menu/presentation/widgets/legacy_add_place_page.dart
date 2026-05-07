part of '../menu_pages.dart';

class LegacyAddPlacePage extends StatelessWidget {
  const LegacyAddPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuFormScaffold(
      title: 'Adicionar Local',
      submitLabel: 'Adicionar Local',
      fields: const [
        _FormFieldData(label: 'Nome do local'),
        _FormFieldData(label: 'Endereço'),
        _FormFieldData(label: 'Referência'),
      ],
      onSubmitMessage: 'Local adicionado.',
    );
  }
}
