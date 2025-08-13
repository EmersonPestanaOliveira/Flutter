import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:manju/controllers/service_controller.dart';
import 'package:manju/views/clients/client_list_screen.dart';
import 'package:manju/views/services/service_form_screen.dart';
import 'package:manju/views/clients/client_form_screen.dart';
import 'package:manju/views/products/product_form_screen.dart';
import 'package:manju/views/products/product_list_screen.dart';
import 'package:manju/views/services/service_calendar_widget.dart';

import '../../data/database-helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  final controller = GetIt.I<ServiceController>();

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      controller.loadServicesByDate(_selectedDate);
    });
  }

  resetDatabase() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.resetDatabase();
  }

  @override
  void initState() {
    super.initState();
    //resetDatabase();
    controller.loadServicesByDate(_selectedDate);
    //controller.loadServices();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: Image.asset(
          'assets/logo.jpg',
          height: 50,
        ),
        title: const Text(
          'Manju',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.people,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const ClientListScreen(),
              ));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ServiceCalendarWidget(
              initialDate: DateTime.now(),
              onDateSelected: _onDateSelected,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                      'dia: ${dateFormat.format(_selectedDate)} || Atendimentos: ${controller.services.length}',
                      style: const TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          final services = controller.services;
                          if (services.isEmpty) {
                            return const Center(child: Text('Nenhum Serviço'));
                          }
                          // Ordenando a lista pelo campo dateTime
                          services
                              .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                          return ListView.builder(
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final service = services[index];
                              return ListTile(
                                leading: Text(
                                    '${service.dateTime.hour} : ${service.dateTime.minute <= 9 ? '0' : ''}${service.dateTime.minute}'),
                                title: Text(service.clientName.toString()),
                                //subtitle: Text(service.productId.toString()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        await Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (_) =>
                                                    const ServiceFormScreen()));
                                        controller.loadServicesByDate(
                                            service.dateTime);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        if (service.id != null) {
                                          await controller
                                              .deleteService(service.id!);
                                          await controller.loadServicesByDate(
                                              service.dateTime);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Wrap(
        spacing: 8,
        direction: Axis.vertical,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'fabService',
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            tooltip: 'Cadastrar Serviço',
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const ServiceFormScreen(),
              ));
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'fabClient',
            child: const Icon(Icons.person_add, color: Colors.white),
            tooltip: 'Cadastrar Cliente',
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const ClientFormScreen(),
              ));
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'fabProduct',
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            tooltip: 'Cadastrar Produto',
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const ProductFormScreen(),
              ));
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'fabProductList',
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            tooltip: 'Listar Produtos',
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const ProductListScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
