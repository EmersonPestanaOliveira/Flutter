import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../data/clients_model.dart';
import '../data/clients_repository.dart';

class ClientsFormPage extends StatefulWidget {
  final ClientModel? client;

  const ClientsFormPage({super.key, this.client});

  @override
  State<ClientsFormPage> createState() => _ClientsFormPageState();
}

class _ClientsFormPageState extends State<ClientsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = ClientsRepository();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController birthdayController;
  late TextEditingController socialController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client?.name ?? '');
    phoneController = TextEditingController(text: widget.client?.phone ?? '');
    emailController = TextEditingController(text: widget.client?.email ?? '');
    socialController = TextEditingController(text: widget.client?.social ?? '');
    birthdayController = TextEditingController(
      text: widget.client?.birthday != null
          ? toBrazilianDate(widget.client!.birthday!)
          : '',
    );
  }

  String toBrazilianDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  DateTime? parseDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final birthday = parseDate(birthdayController.text);

      final client = ClientModel(
        id: widget.client?.id,
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        birthday: birthday,
        social: socialController.text,
      );

      if (widget.client == null) {
        await repo.create(client);
      } else {
        await repo.update(client);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.client != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  PhoneInputFormatter(defaultCountryCode: 'BR'),
                ],
                validator: (value) =>
                    value!.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: birthdayController,
                decoration: const InputDecoration(
                  labelText: 'Data de Aniversário',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [MaskedInputFormatter('##/##/####')],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data de aniversário';
                  }
                  final parsed = parseDate(value);
                  if (parsed == null) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: socialController,
                decoration: const InputDecoration(labelText: 'Redes Sociais'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
