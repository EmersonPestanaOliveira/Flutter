import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manju/controllers/client_controller.dart';
import 'package:manju/controllers/service_controller.dart';
import 'package:manju/views/clients/client_form_screen.dart';

import '../dashboard/dashboard_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final controller = GetIt.I<ClientController>();

  @override
  void initState() {
    super.initState();
    controller.loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
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
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final clients = controller.clients;
          if (clients.isEmpty) {
            return const Center(child: Text('Nenhum cliente cadastrado.'));
          }
          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                title: Text(client.name),
                subtitle: Text(client.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // Editar
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ClientFormScreen(client: client),
                        ));
                        controller.loadClients();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.deleteClient(client.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
