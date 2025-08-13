import '../../domain/etities/image_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required String id,
    required String title,
    required String url,
    required String explanation,
  }) : super(
          id: id,
          title: title,
          url: url,
          explanation: explanation,
        );

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'explanation': explanation,
    };
  }
}
