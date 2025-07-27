import 'financial_database.dart';
import 'transaction_model.dart';
import 'debt_model.dart';

class FinancialRepository {
  final db = FinancialDatabase.instance;

  // 🔸 Entradas e Saídas
  Future<int> createTransaction(TransactionModel transaction) async {
    final database = await db.database;
    return await database.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> readAllTransactions() async {
    final database = await db.database;
    final result = await database.query('transactions');

    final transactions = result
        .map((map) => TransactionModel.fromMap(map))
        .toList();

    transactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return transactions;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final database = await db.database;
    return await database.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final database = await db.database;
    return await database.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔸 Dívidas
  Future<int> createDebt(DebtModel debt) async {
    final database = await db.database;
    return await database.insert('debts', debt.toMap());
  }

  Future<List<DebtModel>> readAllDebts() async {
    final database = await db.database;
    final result = await database.query('debts');

    final debts = result.map((map) => DebtModel.fromMap(map)).toList();

    debts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return debts;
  }

  Future<int> updateDebt(DebtModel debt) async {
    final database = await db.database;
    return await database.update(
      'debts',
      debt.toMap(),
      where: 'id = ?',
      whereArgs: [debt.id],
    );
  }

  Future<int> deleteDebt(int id) async {
    final database = await db.database;
    return await database.delete('debts', where: 'id = ?', whereArgs: [id]);
  }
}
