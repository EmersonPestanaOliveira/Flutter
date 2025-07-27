import 'package:sqflite/sqflite.dart';
import 'clients_database.dart';
import 'clients_model.dart';

class ClientsRepository {
  final db = ClientsDatabase.instance;

  Future<int> create(ClientModel client) async {
    final database = await db.database;
    return await database.insert(
      'clients',
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ClientModel>> readAll() async {
    final database = await db.database;
    final result = await database.query('clients');

    return result.map((map) => ClientModel.fromMap(map)).toList();
  }

  Future<int> update(ClientModel client) async {
    final database = await db.database;
    return await database.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> delete(int id) async {
    final database = await db.database;
    return await database.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final database = await db.database;
    final result = await database.rawQuery(
      'SELECT COUNT(*) as count FROM clients',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
