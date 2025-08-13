import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/product_model.dart';

class ProductFormView extends StatefulWidget {
  final ProductModel? product;
  const ProductFormView({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = AppState.of(context).productViewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o preço' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a quantidade'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final name = _nameController.text;
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final quantity =
                        int.tryParse(_quantityController.text) ?? 0;

                    if (widget.product == null) {
                      // Criar novo produto
                      await productViewModel.addProduct(name, price, quantity);
                    } else {
                      // Editar produto existente
                      await productViewModel.editProduct(
                        widget.product!.id,
                        name,
                        price,
                        quantity,
                      );
                    }

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(widget.product == null ? 'Adicionar' : 'Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
