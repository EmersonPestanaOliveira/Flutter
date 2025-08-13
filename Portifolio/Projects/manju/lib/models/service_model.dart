class ServiceModel {
  final int? id;
  final int? clientId;
  final int? productId;
  final String? clientName;
  final DateTime dateTime; // data/hora do serviço

  ServiceModel({
    this.id,
    required this.clientId,
    required this.productId,
    required this.clientName,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'productId': productId,
      'clientName': clientName,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      clientId: map['clientId'],
      productId: map['productId'],
      clientName: map['clientName'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
