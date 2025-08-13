import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manju/controllers/client_controller.dart';
import 'package:manju/controllers/product_controller.dart';
import 'package:manju/controllers/service_controller.dart';
import 'package:manju/models/client_model.dart';
import 'package:manju/models/service_model.dart';

import '../dashboard/dashboard_screen.dart';

class ServiceFormScreen extends StatefulWidget {
  const ServiceFormScreen({super.key});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final clientController = GetIt.I<ClientController>();
  final productController = GetIt.I<ProductController>();
  final serviceController = GetIt.I<ServiceController>();

  int? id = 0;
  String? name = '';
  Client? _selectedClient;
  int? _selectedProductId;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    clientController.loadClients();
    productController.loadProducts();
  }

  void _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Serviço'),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ));
            },
            icon: Icon(
              Icons.arrow_back,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: [
                // Seletor de cliente
                AnimatedBuilder(
                  animation: clientController,
                  builder: (context, _) {
                    final clients = clientController.clients;
                    return DropdownButton<Client>(
                      hint: name == ''
                          ? const Text('Selecione um cliente')
                          : Text(name ?? ''),
                      value: _selectedClient,
                      items: clients.map((c) {
                        return DropdownMenuItem<Client>(
                          value: Client(id: c.id, name: c.name, phone: c.phone),
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          id = value?.id;
                          name = value?.name;
                        });
                      },
                    );
                  },
                ),
                // Seletor de produto
                AnimatedBuilder(
                  animation: productController,
                  builder: (context, _) {
                    final products = productController.products;
                    return DropdownButton<int>(
                      hint: const Text('Selecione um produto'),
                      value: _selectedProductId,
                      items: products.map((p) {
                        return DropdownMenuItem<int>(
                          value: p.id,
                          child: Text(p.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProductId = value;
                        });
                      },
                    );
                  },
                ),
                // Seletor de data e hora
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Selecionar data/hora'),
                ),
                if (_selectedDateTime != null) Text('$_selectedDateTime'),
                // Botão salvar
                ElevatedButton(
                  onPressed: () async {
                    if (id != null &&
                        _selectedProductId != null &&
                        _selectedDateTime != null) {
                      final newService = ServiceModel(
                        clientId: id,
                        productId: id,
                        clientName: name,
                        dateTime: _selectedDateTime!,
                      );
                      await serviceController.addService(newService);

                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ));
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
