import 'package:manju/models/service_model.dart';
import '../database-helper.dart';

class ServiceRepository {
  Future<int> insertService(ServiceModel service) async {
    final db = await DatabaseHelper().database;
    return await db.insert('services', service.toMap());
  }

  Future<List<ServiceModel>> getAllServices() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('services');
    return maps.map((map) => ServiceModel.fromMap(map)).toList();
  }

  Future<int> deleteService(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('services', where: 'id = ?', whereArgs: [id]);
  }

  /// Retorna os serviços apenas do dia selecionado
  Future<List<ServiceModel>> getServicesByDate(DateTime date) async {
    final db = await DatabaseHelper().database;
    // Filtrar por dia (ignorando horário): usar substring de dateTime ou comparações
    final String startDate =
        DateTime(date.year, date.month, date.day).toIso8601String();
    final String endDate =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query('services',
        where: 'dateTime BETWEEN ? AND ?', whereArgs: [startDate, endDate]);

    return maps.map((map) => ServiceModel.fromMap(map)).toList();
  }
}
