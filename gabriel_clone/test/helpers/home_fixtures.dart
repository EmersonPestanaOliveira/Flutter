import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/entities/camera.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';

const testCamera = Camera(
  id: 'camera-1',
  nome: 'Camera Paulista',
  latitude: -23.5614,
  longitude: -46.6559,
  ativo: true,
);

final testAlerta = Alerta(
  id: 'alerta-1',
  bairro: 'Bela Vista',
  cidade: 'Sao Paulo',
  data: DateTime(2026, 4, 26),
  descricao: 'Ocorrencia de teste',
  tipo: AlertaTipo.rouboFurto,
  latitude: -23.5614,
  longitude: -46.6559,
);