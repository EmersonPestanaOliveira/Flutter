import 'package:hive/hive.dart';
import '../models/product_model.dart';

class ProductRepository {
  static const String boxName = 'productsBox';

  Future<void> addProduct(ProductModel product) async {
    final box = await Hive.openBox<ProductModel>(boxName);
    await box.put(product.id, product);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final box = await Hive.openBox<ProductModel>(boxName);
    return box.values.toList();
  }

  Future<void> updateProduct(ProductModel product) async {
    final box = await Hive.openBox<ProductModel>(boxName);
    await box.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    final box = await Hive.openBox<ProductModel>(boxName);
    await box.delete(id);
  }
}
