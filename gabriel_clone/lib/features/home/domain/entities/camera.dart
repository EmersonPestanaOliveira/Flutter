import 'package:equatable/equatable.dart';

class Camera extends Equatable {
  const Camera({
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.ativo,
    this.rua = '',
    this.bairro = '',
    this.cidade = '',
    this.regiao = '',
    this.linkAoVivo = '',
    this.users = const [],
    this.cep = '',
    this.numero = '',
  });

  final String id;
  final String nome;
  final double latitude;
  final double longitude;
  final bool ativo;
  final String rua;
  final String bairro;
  final String cidade;
  final String regiao;
  final String linkAoVivo;
  final List<String> users;
  final String cep;
  final String numero;

  @override
  List<Object?> get props => [
    id,
    nome,
    latitude,
    longitude,
    ativo,
    rua,
    bairro,
    cidade,
    regiao,
    linkAoVivo,
    users,
    cep,
    numero,
  ];
}
