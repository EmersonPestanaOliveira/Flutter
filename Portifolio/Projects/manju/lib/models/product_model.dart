class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? imagePath; // caminho local da imagem

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
