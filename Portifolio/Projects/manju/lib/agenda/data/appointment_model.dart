class AppointmentModel {
  final int? id;
  final int clientId;
  final String clientName;
  final DateTime date;
  final String time;

  final int productId;
  final String productName;

  AppointmentModel({
    this.id,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.time,
    required this.productId,
    required this.productName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'date': date.toIso8601String(),
      'time': time,
      'productId': productId,
      'productName': productName,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      clientId: map['clientId'],
      clientName: map['clientName'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      productId: map['productId'],
      productName: map['productName'],
    );
  }
}
