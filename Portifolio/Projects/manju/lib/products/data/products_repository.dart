import 'products_database.dart';
import 'product_model.dart';

class ProductsRepository {
  final db = ProductsDatabase.instance;

  Future<int> create(ProductModel product) async {
    final database = await db.database;
    return await database.insert('products', product.toMap());
  }

  Future<List<ProductModel>> readAll() async {
    final database = await db.database;
    final result = await database.query('products');

    final products = result.map((map) => ProductModel.fromMap(map)).toList();

    products.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return products;
  }

  Future<int> update(ProductModel product) async {
    final database = await db.database;
    return await database.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final database = await db.database;
    return await database.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<ProductModel?> readById(int id) async {
    final database = await db.database;
    final result = await database.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return ProductModel.fromMap(result.first);
    } else {
      return null;
    }
  }
}
