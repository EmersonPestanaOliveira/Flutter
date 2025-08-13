import 'package:manju/models/product_model.dart';
import '../database-helper.dart';

class ProductRepository {
  Future<int> insertProduct(Product product) async {
    final db = await DatabaseHelper().database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await DatabaseHelper().database;
    return await db.update('products', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
