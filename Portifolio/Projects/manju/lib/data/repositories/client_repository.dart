import 'package:manju/models/client_model.dart';
import '../database-helper.dart';

class ClientRepository {
  Future<int> insertClient(Client client) async {
    final db = await DatabaseHelper().database;
    return await db.insert('clients', client.toMap());
  }

  Future<List<Client>> getAllClients() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('clients');
    return maps.map((map) => Client.fromMap(map)).toList();
  }

  Future<int> updateClient(Client client) async {
    final db = await DatabaseHelper().database;
    return await db.update('clients', client.toMap(),
        where: 'id = ?', whereArgs: [client.id]);
  }

  Future<int> deleteClient(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }
}
