import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta_filter.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/presentation/utils/home_filter_utils.dart';

void main() {
  final perto = Alerta(
    id: 'perto',
    bairro: 'Bela Vista',
    cidade: 'Sao Paulo',
    data: DateTime(2026, 5, 6),
    descricao: 'Perto',
    tipo: AlertaTipo.rouboFurto,
    latitude: -23.5614,
    longitude: -46.6559,
  );

  final longe = Alerta(
    id: 'longe',
    bairro: 'Santo Andre',
    cidade: 'Santo Andre',
    data: DateTime(2026, 5, 6),
    descricao: 'Longe',
    tipo: AlertaTipo.vandalismo,
    latitude: -23.6563,
    longitude: -46.5322,
  );

  test('filtra por tipo e data', () {
    final result = applyFilter(
      [perto, longe],
      AlertaFilter(
        tipos: {AlertaTipo.rouboFurto},
        dateFrom: DateTime(2026, 5, 1),
        dateTo: DateTime(2026, 5, 10),
      ),
    );

    expect(result, [perto]);
  });

  test('filtra por raio usando haversine', () {
    final result = applyFilter(
      [perto, longe],
      const AlertaFilter(
        radius: 2,
        centerLatitude: -23.5614,
        centerLongitude: -46.6559,
      ),
    );

    expect(result, [perto]);
  });
}
