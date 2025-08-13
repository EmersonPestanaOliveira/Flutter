import 'package:flutter/material.dart';
import '../data/transaction_model.dart';
import '../data/financial_repository.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionModel? transaction;
  final String? initialName;
  final double? initialValue;
  final bool isEntrada;

  const TransactionFormPage({
    super.key,
    this.transaction,
    this.initialName,
    this.initialValue,
    this.isEntrada = true,
  });

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = FinancialRepository();

  late TextEditingController descriptionController;
  late TextEditingController valueController;
  late bool isEntradaSelecionado;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    isEntradaSelecionado = widget.transaction?.type == 'entrada'
        ? true
        : widget.transaction?.type == 'saida'
        ? false
        : widget.isEntrada;

    descriptionController = TextEditingController(
      text: widget.transaction?.description ?? widget.initialName ?? '',
    );

    valueController = TextEditingController(
      text: widget.transaction != null
          ? widget.transaction!.value.toStringAsFixed(2)
          : widget.initialValue != null
          ? widget.initialValue!.toStringAsFixed(2)
          : '',
    );

    selectedDate = widget.transaction?.dateTime ?? DateTime.now();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final tx = TransactionModel(
        id: widget.transaction?.id,
        type: isEntradaSelecionado ? 'entrada' : 'saida', // 🔥 Correção
        value: double.parse(valueController.text.replaceAll(',', '.')),
        dateTime: selectedDate,
        description: descriptionController.text.trim(),
      );

      if (widget.transaction?.id == null) {
        await repo.createTransaction(tx);
      } else {
        await repo.updateTransaction(tx);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (time == null) return;

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction?.id != null;
    final label = isEntradaSelecionado ? 'Entrada' : 'Saída';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar $label' : 'Nova $label'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🔥 Descrição
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Digite a descrição'
                    : null,
              ),

              const SizedBox(height: 12),

              /// 🔥 Valor
              TextFormField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o valor';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// 🔥 Data e hora
              ListTile(
                title: Text(
                  '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year} - ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),

              const SizedBox(height: 16),

              /// 🔥 Seletor Entrada/Saída
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Entrada'),
                    selected: isEntradaSelecionado,
                    onSelected: (selected) {
                      setState(() {
                        isEntradaSelecionado = true;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Saída'),
                    selected: !isEntradaSelecionado,
                    onSelected: (selected) {
                      setState(() {
                        isEntradaSelecionado = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 🔥 Botão Salvar
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
