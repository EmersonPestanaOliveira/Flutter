import 'agenda_database.dart';
import 'appointment_model.dart';

class AgendaRepository {
  final db = AgendaDatabase.instance;

  Future<int> create(AppointmentModel appointment) async {
    final database = await db.database;
    return await database.insert('appointments', appointment.toMap());
  }

  Future<List<AppointmentModel>> readAll() async {
    final database = await db.database;
    final result = await database.query('appointments');

    return result.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  Future<int> update(AppointmentModel appointment) async {
    final database = await db.database;
    return await database.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<void> createBatch(List<AppointmentModel> appointments) async {
    final database = await db.database;
    final batch = database.batch();
    for (var appointment in appointments) {
      batch.insert('appointments', appointment.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<int> delete(int id) async {
    final database = await db.database;
    return await database.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
