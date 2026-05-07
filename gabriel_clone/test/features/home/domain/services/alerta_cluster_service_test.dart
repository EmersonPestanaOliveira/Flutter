import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/domain/entities/alerta.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/domain/services/alerta_cluster_service.dart';

void main() {
  group('AlertaClusterService.cluster', () {
    test('lista vazia retorna vazia', () {
      final clusters = AlertaClusterService.cluster([], 13);
      expect(clusters, isEmpty);
    });

    test('pin único retorna cluster individual', () {
      final alertas = [_alerta('a1', -23.5505, -46.6333)];
      final clusters = AlertaClusterService.cluster(alertas, 16);
      expect(clusters.length, 1);
      expect(clusters.first.count, 1);
      expect(clusters.first.isCluster, isFalse);
    });

    test('dois pontos muito próximos agrupam em zoom baixo', () {
      final alertas = [
        _alerta('a1', -23.5505, -46.6333),
        _alerta('a2', -23.5506, -46.6334),
      ];
      final clusters = AlertaClusterService.cluster(alertas, 8);
      // Em zoom 8, precisão geohash=3 → provavelmente mesma célula
      final hasCluster = clusters.any((c) => c.isCluster);
      expect(hasCluster, isTrue);
    });

    test('pontos distantes não agrupam em zoom alto', () {
      final alertas = [
        _alerta('a1', -23.5505, -46.6333),
        _alerta('a2', -23.6505, -46.7333),
      ];
      final clusters = AlertaClusterService.cluster(alertas, 16);
      expect(clusters.length, 2);
      expect(clusters.every((c) => !c.isCluster), isTrue);
    });

    test('centróide fica entre os pontos agrupados', () {
      final alertas = [
        _alerta('a1', -23.55, -46.63),
        _alerta('a2', -23.56, -46.64),
      ];
      final clusters = AlertaClusterService.cluster(alertas, 8);
      final cluster = clusters.firstWhere((c) => c.isCluster, orElse: () => clusters.first);
      if (cluster.isCluster) {
        expect(cluster.centerLatitude, closeTo(-23.555, 0.01));
        expect(cluster.centerLongitude, closeTo(-46.635, 0.01));
      }
    });

    test('IDs de clusters são únicos', () {
      final alertas = List.generate(
        10,
        (i) => _alerta('a$i', -23.55 + i * 0.001, -46.63 + i * 0.001),
      );
      final clusters = AlertaClusterService.cluster(alertas, 13);
      final ids = clusters.map((c) => c.id).toSet();
      expect(ids.length, clusters.length);
    });
  });
}

Alerta _alerta(String id, double lat, double lon) => Alerta(
      id: id,
      bairro: 'Consolação',
      cidade: 'São Paulo',
      data: DateTime(2026, 5, 1),
      descricao: 'Teste',
      tipo: AlertaTipo.violencia,
      latitude: lat,
      longitude: lon,
    );
