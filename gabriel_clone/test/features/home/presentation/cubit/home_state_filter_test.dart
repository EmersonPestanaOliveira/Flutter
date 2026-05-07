import 'package:flutter_test/flutter_test.dart';

import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta_filter.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/presentation/utils/home_filter_utils.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Alerta _alerta({
  String id = '1',
  AlertaTipo tipo = AlertaTipo.violencia,
  DateTime? data,
  double latitude = -23.5,
  double longitude = -46.6,
  String bairro = 'Centro',
  String cidade = 'São Paulo',
}) =>
    Alerta(
      id: id,
      bairro: bairro,
      cidade: cidade,
      data: data ?? DateTime(2026, 5, 6),
      descricao: 'desc',
      tipo: tipo,
      latitude: latitude,
      longitude: longitude,
    );

// ---------------------------------------------------------------------------
// applyFilter — filtro de domínio
// ---------------------------------------------------------------------------

void main() {
  group('applyFilter — sem filtro', () {
    test('retorna a lista original quando filtro está vazio', () {
      final alertas = [_alerta(id: '1'), _alerta(id: '2')];
      final result = applyFilter(alertas, const AlertaFilter());
      expect(result, alertas);
    });
  });

  group('applyFilter — filtro por tipo', () {
    final alertas = [
      _alerta(id: '1', tipo: AlertaTipo.violencia),
      _alerta(id: '2', tipo: AlertaTipo.acidente),
      _alerta(id: '3', tipo: AlertaTipo.vandalismo),
    ];

    test('retorna apenas alertas do tipo selecionado', () {
      final filter = const AlertaFilter(tipos: {AlertaTipo.acidente});
      final result = applyFilter(alertas, filter);
      expect(result.length, 1);
      expect(result.single.id, '2');
    });

    test('conjunto vazio de tipos retorna todos', () {
      final result = applyFilter(alertas, const AlertaFilter(tipos: {}));
      expect(result.length, 3);
    });

    test('múltiplos tipos retornam todos os correspondentes', () {
      final filter = const AlertaFilter(
        tipos: {AlertaTipo.violencia, AlertaTipo.vandalismo},
      );
      final result = applyFilter(alertas, filter);
      expect(result.map((a) => a.id).toSet(), {'1', '3'});
    });
  });

  group('applyFilter — filtro por data', () {
    final alertas = [
      _alerta(id: '1', data: DateTime(2026, 5, 1)),
      _alerta(id: '2', data: DateTime(2026, 5, 6)),
      _alerta(id: '3', data: DateTime(2026, 5, 10)),
    ];

    test('dateFrom exclui alertas anteriores à data', () {
      final filter = AlertaFilter(dateFrom: DateTime(2026, 5, 6));
      final result = applyFilter(alertas, filter);
      expect(result.map((a) => a.id).toSet(), {'2', '3'});
    });

    test('dateTo exclui alertas posteriores à data', () {
      final filter = AlertaFilter(dateTo: DateTime(2026, 5, 6));
      final result = applyFilter(alertas, filter);
      expect(result.map((a) => a.id).toSet(), {'1', '2'});
    });

    test('dateFrom + dateTo cria intervalo fechado', () {
      final filter = AlertaFilter(
        dateFrom: DateTime(2026, 5, 6),
        dateTo: DateTime(2026, 5, 6),
      );
      final result = applyFilter(alertas, filter);
      expect(result.length, 1);
      expect(result.single.id, '2');
    });

    test('intervalo que exclui tudo retorna lista vazia', () {
      final filter = AlertaFilter(
        dateFrom: DateTime(2026, 5, 15),
        dateTo: DateTime(2026, 5, 20),
      );
      final result = applyFilter(alertas, filter);
      expect(result, isEmpty);
    });
  });

  group('applyFilter — filtro por raio', () {
    // Referência: Praça da Sé, SP ≈ -23.5503, -46.6334
    final center = (-23.5503, -46.6334);
    final alertas = [
      // ~0 km do centro
      _alerta(id: 'perto', latitude: -23.5504, longitude: -46.6335),
      // ~1.5 km do centro (Liberdade)
      _alerta(id: 'medio', latitude: -23.5590, longitude: -46.6340),
      // ~12 km do centro (Pinheiros)
      _alerta(id: 'longe', latitude: -23.5656, longitude: -46.6987),
    ];

    test('radius 1 km retém apenas o alerta muito próximo', () {
      final filter = AlertaFilter(
        radius: 1.0,
        centerLatitude: center.$1,
        centerLongitude: center.$2,
      );
      final result = applyFilter(alertas, filter);
      expect(result.map((a) => a.id), contains('perto'));
      expect(result.map((a) => a.id), isNot(contains('longe')));
    });

    test('radius grande o suficiente inclui todos', () {
      final filter = AlertaFilter(
        radius: 50.0,
        centerLatitude: center.$1,
        centerLongitude: center.$2,
      );
      final result = applyFilter(alertas, filter);
      expect(result.length, alertas.length);
    });
  });

  group('applyFilter — combinação tipo + data', () {
    final alertas = [
      _alerta(id: '1', tipo: AlertaTipo.acidente, data: DateTime(2026, 5, 1)),
      _alerta(id: '2', tipo: AlertaTipo.violencia, data: DateTime(2026, 5, 6)),
      _alerta(id: '3', tipo: AlertaTipo.acidente, data: DateTime(2026, 5, 10)),
    ];

    test('tipo + dateFrom filtra corretamente', () {
      final filter = AlertaFilter(
        tipos: const {AlertaTipo.acidente},
        dateFrom: DateTime(2026, 5, 5),
      );
      final result = applyFilter(alertas, filter);
      expect(result.length, 1);
      expect(result.single.id, '3');
    });
  });

  // ---------------------------------------------------------------------------
  // applyAlertFilters — filtro de apresentação (query de texto + bairro etc.)
  // ---------------------------------------------------------------------------

  group('applyAlertFilters', () {
    final alertas = [
      _alerta(id: '1', tipo: AlertaTipo.violencia, bairro: 'Centro', cidade: 'São Paulo'),
      _alerta(id: '2', tipo: AlertaTipo.acidente, bairro: 'Pinheiros', cidade: 'São Paulo'),
      _alerta(id: '3', tipo: AlertaTipo.estelionato, bairro: 'Morumbi', cidade: 'São Paulo'),
    ];

    test('query vazia retorna tudo', () {
      final result = applyAlertFilters(alertas, query: '', bairro: null, cidade: null, dateKey: null, tipo: null);
      expect(result.length, alertas.length);
    });

    test('filtra por bairro exato', () {
      final result = applyAlertFilters(alertas, query: '', bairro: 'Centro', cidade: null, dateKey: null, tipo: null);
      expect(result.length, 1);
      expect(result.single.id, '1');
    });

    test('filtra por tipo enum', () {
      final result = applyAlertFilters(alertas, query: '', bairro: null, cidade: null, dateKey: null, tipo: AlertaTipo.acidente);
      expect(result.length, 1);
      expect(result.single.id, '2');
    });

    test('query textual match case-insensitive no bairro', () {
      final result = applyAlertFilters(alertas, query: 'morumbi', bairro: null, cidade: null, dateKey: null, tipo: null);
      expect(result.length, 1);
      expect(result.single.id, '3');
    });

    test('combinação bairro + tipo retorna interseção', () {
      final result = applyAlertFilters(alertas, query: '', bairro: 'Pinheiros', cidade: null, dateKey: null, tipo: AlertaTipo.violencia);
      // Pinheiros não tem violencia → lista vazia
      expect(result, isEmpty);
    });
  });
}
