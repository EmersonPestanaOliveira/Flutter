import 'package:flutter/foundation.dart';
import 'package:manju/data/repositories/client_repository.dart';
import 'package:manju/models/client_model.dart';

class ClientController extends ChangeNotifier {
  final ClientRepository clientRepository;

  ClientController(this.clientRepository);

  List<Client> _clients = [];
  List<Client> get clients => _clients;

  Future<void> loadClients() async {
    _clients = await clientRepository.getAllClients();
    notifyListeners();
  }

  Future<void> addClient(Client client) async {
    await clientRepository.insertClient(client);
    await loadClients();
  }

  Future<void> updateClient(Client client) async {
    if (client.id != null) {
      await clientRepository.updateClient(client);
      await loadClients();
    }
  }

  Future<void> deleteClient(int id) async {
    await clientRepository.deleteClient(id);
    await loadClients();
  }
}
