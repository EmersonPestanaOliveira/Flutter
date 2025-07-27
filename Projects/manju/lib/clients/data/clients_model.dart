class ClientModel {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final DateTime? birthday;
  final String? social;

  ClientModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.birthday,
    this.social,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'birthday': birthday?.toIso8601String(),
      'social': social,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'])
          : null,
      social: map['social'] as String?,
    );
  }
}
