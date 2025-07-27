import 'package:flutter/material.dart';
import '../data/debt_model.dart';
import '../data/financial_repository.dart';

class DebtFormPage extends StatefulWidget {
  final DebtModel? debt;

  const DebtFormPage({super.key, this.debt});

  @override
  State<DebtFormPage> createState() => _DebtFormPageState();
}

class _DebtFormPageState extends State<DebtFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = FinancialRepository();

  late TextEditingController nameController;
  late TextEditingController totalValueController;
  late TextEditingController paidValueController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.debt?.name ?? '');
    totalValueController = TextEditingController(
      text: widget.debt != null
          ? widget.debt!.totalValue.toStringAsFixed(2)
          : '',
    );
    paidValueController = TextEditingController(
      text: widget.debt != null
          ? widget.debt!.paidValue.toStringAsFixed(2)
          : '',
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final debt = DebtModel(
        id: widget.debt?.id,
        name: nameController.text.trim(),
        totalValue: double.parse(
          totalValueController.text.replaceAll(',', '.'),
        ),
        paidValue: double.parse(paidValueController.text.replaceAll(',', '.')),
      );

      if (widget.debt == null) {
        await repo.createDebt(debt);
      } else {
        await repo.updateDebt(debt);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.debt != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Dívida' : 'Nova Dívida'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Dívida'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o nome' : null,
              ),
              TextFormField(
                controller: totalValueController,
                decoration: const InputDecoration(labelText: 'Valor Total'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o valor total';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: paidValueController,
                decoration: const InputDecoration(labelText: 'Valor Pago'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o valor pago';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text(isEditing ? 'Salvar Alterações' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
