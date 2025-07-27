import 'package:flutter/material.dart';
import '../data/product_model.dart';
import '../data/products_repository.dart';

class ProductsFormPage extends StatefulWidget {
  final ProductModel? product;

  const ProductsFormPage({super.key, this.product});

  @override
  State<ProductsFormPage> createState() => _ProductsFormPageState();
}

class _ProductsFormPageState extends State<ProductsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = ProductsRepository();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController durationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(
      text: widget.product != null
          ? widget.product!.price.toStringAsFixed(2)
          : '',
    );
    durationController = TextEditingController(
      text: widget.product != null
          ? widget.product!.durationMinutes.toString()
          : '',
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        id: widget.product?.id,
        name: nameController.text.trim(),
        price: double.parse(priceController.text.replaceAll(',', '.')),
        durationMinutes: int.tryParse(durationController.text) ?? 0,
      );

      if (widget.product == null) {
        await repo.create(product);
      } else {
        await repo.update(product);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
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
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o nome' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Preço (R\$)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o preço';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Digite um valor válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Duração (minutos)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a duração';
                  }
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Digite um número válido';
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
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
