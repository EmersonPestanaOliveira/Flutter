class CategoryModel {
  final String id;
  final String name;
  final String imageUrl; // Caso tenha uma imagem associada à categoria

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '', // Verifica se há um campo 'imageUrl'
    );
  }
}
