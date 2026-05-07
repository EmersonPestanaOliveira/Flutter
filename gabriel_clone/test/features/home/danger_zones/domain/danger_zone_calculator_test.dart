import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/danger_zones/domain/danger_zone_calculator.dart';
import 'package:gabriel_clone/features/home/danger_zones/domain/danger_zone_config.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';

void main() {
  const calculator = DangerZoneCalculator();
  final now = DateTime(2026, 4, 30, 12);
  const config = DangerZoneConfig(
    enabled: true,
    minEvents: 3,
    radiusMeters: 300,
    timeWindowHours: 72,
    notificationCooldownMinutes: 60,
  );

  test('nao calcula zonas quando feature flag esta desligada', () {
    final zones = calculator.calculate(
      events: [
        _alerta(id: '1', tipo: AlertaTipo.rouboFurto, now: now),
        _alerta(id: '2', tipo: AlertaTipo.rouboFurto, now: now),
        _alerta(id: '3', tipo: AlertaTipo.rouboFurto, now: now),
      ],
      config: DangerZoneConfig.disabled,
      now: now,
    );

    expect(zones, isEmpty);
  });

  test('cria zona quando ha eventos iguais concentrados no raio', () {
    final zones = calculator.calculate(
      events: [
        _alerta(id: '1', tipo: AlertaTipo.rouboFurto, now: now),
        _alerta(
          id: '2',
          tipo: AlertaTipo.rouboFurto,
          now: now,
          latitude: -23.5508,
        ),
        _alerta(
          id: '3',
          tipo: AlertaTipo.rouboFurto,
          now: now,
          longitude: -46.6338,
        ),
      ],
      config: config,
      now: now,
    );

    expect(zones, hasLength(1));
    expect(zones.single.eventType, AlertaTipo.rouboFurto.label);
    expect(zones.single.eventCount, 3);
    expect(zones.single.radiusMeters, 300);
  });

  test('nao mistura tipos de eventos diferentes', () {
    final zones = calculator.calculate(
      events: [
        _alerta(id: '1', tipo: AlertaTipo.rouboFurto, now: now),
        _alerta(id: '2', tipo: AlertaTipo.rouboFurto, now: now),
        _alerta(id: '3', tipo: AlertaTipo.invasao, now: now),
      ],
      config: config,
      now: now,
    );

    expect(zones, isEmpty);
  });

  test('ignora eventos fora da janela configurada', () {
    final oldDate = now.subtract(const Duration(hours: 90));

    final zones = calculator.calculate(
      events: [
        _alerta(id: '1', tipo: AlertaTipo.vandalismo, now: now),
        _alerta(id: '2', tipo: AlertaTipo.vandalismo, now: now),
        _alerta(id: '3', tipo: AlertaTipo.vandalismo, now: oldDate),
      ],
      config: config,
      now: now,
    );

    expect(zones, isEmpty);
  });

  test('evita zonas duplicadas muito proximas do mesmo tipo', () {
    final zones = calculator.calculate(
      events: [
        _alerta(id: '1', tipo: AlertaTipo.acidente, now: now),
        _alerta(
          id: '2',
          tipo: AlertaTipo.acidente,
          now: now,
          latitude: -23.5507,
        ),
        _alerta(
          id: '3',
          tipo: AlertaTipo.acidente,
          now: now,
          longitude: -46.6337,
        ),
        _alerta(
          id: '4',
          tipo: AlertaTipo.acidente,
          now: now,
          latitude: -23.5509,
        ),
      ],
      config: config,
      now: now,
    );

    expect(zones, hasLength(1));
    expect(zones.single.eventCount, 4);
  });
}

Alerta _alerta({
  required String id,
  required AlertaTipo tipo,
  required DateTime now,
  double latitude = -23.5505,
  double longitude = -46.6333,
}) {
  return Alerta(
    id: id,
    bairro: 'Se',
    cidade: 'Sao Paulo',
    data: now,
    descricao: 'Evento',
    tipo: tipo,
    latitude: latitude,
    longitude: longitude,
  );
}
