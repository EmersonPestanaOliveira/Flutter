import 'package:hive/hive.dart';

part 'product_model.g.dart'; // Gerado pelo build_runner

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
