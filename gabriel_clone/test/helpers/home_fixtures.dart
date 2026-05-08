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

List<Alerta> syntheticAlertas(int count) {
  return List<Alerta>.generate(count, (index) {
    final row = index ~/ 250;
    final col = index % 250;
    return Alerta(
      id: 'alerta-$index',
      bairro: 'Bairro ${row % 20}',
      cidade: 'Sao Paulo',
      data: DateTime(2026, 4, 1).add(Duration(days: index % 30)),
      descricao: 'Ocorrencia sintetica $index',
      tipo: AlertaTipo.values[index % AlertaTipo.values.length],
      latitude: -23.75 + row * 0.0015,
      longitude: -46.85 + col * 0.0015,
    );
  }, growable: false);
}
