import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/clients_model.dart';
import '../data/clients_repository.dart';
import 'clients_form_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final repo = ClientsRepository();
  List<ClientModel> clients = [];
  int total = 0;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'clients.db');
    await deleteDatabase(path);
    print('Banco apagado!');
  }

  String cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> callPhone(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri url = Uri(scheme: 'tel', path: clean);

    if (Platform.isAndroid) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Não foi possível ligar';
      }
    }
  }

  Future<void> openWhatsApp(String phone, {String message = ''}) async {
    final clean = cleanPhone(phone);

    // Adiciona DDI se não tiver
    final phoneWithDdi = clean.startsWith('55') ? clean : '55$clean';
    final text = Uri.encodeComponent(message);

    final Uri whatsappUrl = Uri.parse(
      'whatsapp://send?phone=$phoneWithDdi&text=$text',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      final Uri webUrl = Uri.parse('https://wa.me/$phoneWithDdi?text=$text');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o WhatsApp para $phoneWithDdi';
      }
    }
  }

  Future<void> _loadClients() async {
    final data = await repo.readAll();
    data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final count = await repo.count();
    setState(() {
      clients = data;
      total = count;
    });
  }

  void _deleteClient(int id) async {
    await repo.delete(id);
    _loadClients();
  }

  void _navigateToForm({ClientModel? client}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClientsFormPage(client: client)),
    );
    _loadClients();
  }

  Future<bool?> showDeleteConfirmation(
    BuildContext context,
    ClientModel? client,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente excluir o cliente "${client?.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Total de clientes: $total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: clients.isEmpty
                      ? const Center(child: Text('Nenhum cliente cadastrado'))
                      : ListView.builder(
                          itemCount: clients.length,
                          itemBuilder: (context, index) {
                            final client = clients[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/clients_profile',
                                  arguments: client,
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Text(
                                              client.name.isNotEmpty
                                                  ? client.name
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  client.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Telefone: ${client.phone}',
                                                ),
                                                Text(
                                                  'Email: ${client.email.isNotEmpty ? client.email : 'Não informado'}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _buildAction(
                                            icon: Icons.edit,
                                            color: Colors.blue,
                                            onTap: () =>
                                                _navigateToForm(client: client),
                                          ),
                                          _buildAction(
                                            icon: Icons.delete,
                                            color: Colors.red,
                                            onTap: () async {
                                              final confirmed =
                                                  await showDeleteConfirmation(
                                                    context,
                                                    client,
                                                  );
                                              if (confirmed == true) {
                                                _deleteClient(client.id!);
                                              }
                                            },
                                          ),

                                          _buildAction(
                                            iconData: FontAwesomeIcons.whatsapp,
                                            color: Colors.teal,
                                            onTap: () =>
                                                openWhatsApp(client.phone),
                                          ),
                                          _buildAction(
                                            icon: Icons.phone,
                                            color: Colors.green,
                                            onTap: () =>
                                                callPhone(client.phone),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAction({
    IconData? icon,
    IconData? iconData,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.grey[200],
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: icon != null
            ? Icon(icon, color: color)
            : FaIcon(iconData, color: color),
        onPressed: onTap,
      ),
    );
  }
}
