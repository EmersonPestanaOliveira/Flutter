import 'package:equatable/equatable.dart';

class Camera extends Equatable {
  const Camera({
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.ativo,
  });

  final String id;
  final String nome;
  final double latitude;
  final double longitude;
  final bool ativo;

  @override
  List<Object?> get props => [id, nome, latitude, longitude, ativo];
}