class TransactionModel {
  final int? id;
  final String type; // 'entrada' ou 'saida'
  final double value;
  final DateTime dateTime;
  final String description;

  TransactionModel({
    this.id,
    required this.type,
    required this.value,
    required this.dateTime,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      value: map['value'],
      dateTime: DateTime.parse(map['dateTime']),
      description: map['description'],
    );
  }
}
