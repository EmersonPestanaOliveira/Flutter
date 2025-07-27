class ProductModel {
  final int? id;
  final String name;
  final double price;
  final int durationMinutes;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'durationMinutes': durationMinutes,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : map['price'],
      durationMinutes: map['durationMinutes'] ?? 0,
    );
  }
}
