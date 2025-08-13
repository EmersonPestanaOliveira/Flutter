class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl; // URL da imagem do produto

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  // Método que converte JSON para um objeto ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'] ?? '', // Verifica se há uma URL de imagem
    );
  }
}
