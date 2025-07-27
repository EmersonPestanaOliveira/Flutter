class DebtModel {
  final int? id;
  final String name;
  final double totalValue;
  final double paidValue;

  DebtModel({
    this.id,
    required this.name,
    required this.totalValue,
    required this.paidValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalValue': totalValue,
      'paidValue': paidValue,
    };
  }

  factory DebtModel.fromMap(Map<String, dynamic> map) {
    return DebtModel(
      id: map['id'],
      name: map['name'],
      totalValue: map['totalValue'],
      paidValue: map['paidValue'],
    );
  }
}
