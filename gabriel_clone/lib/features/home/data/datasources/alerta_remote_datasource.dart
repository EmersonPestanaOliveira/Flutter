import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/geo/geo_utils.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../models/alerta_model.dart';

abstract interface class AlertaRemoteDatasource {
  Future<List<AlertaModel>> getAlertas();
  Future<List<AlertaModel>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  });
}

class AlertaRemoteDatasourceImpl implements AlertaRemoteDatasource {
  const AlertaRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  /// Limite máximo de documentos por query (evita over-fetch em produção).
  static const int _maxPerRange = 500;

  @override
  Future<List<AlertaModel>> getAlertas() async {
    try {
      final snapshot = await firestore
          .collection('alertas')
          .orderBy('data', descending: true)
          .limit(2000)
          .get();

      return snapshot.docs.map(AlertaModel.fromFirestore).toList();
    } catch (error) {
      throw BackendErrorMapper.toFailure(error);
    }
  }

  /// Busca alertas no viewport usando múltiplos geohash ranges.
  ///
  /// Estratégia multi-range:
  /// 1. Divide o bounds em grade N×N de células.
  /// 2. Calcula geohash de cada célula.
  /// 3. Consolida em ranges [lower, upper] contínuos.
  /// 4. Executa uma query Firestore por range em paralelo.
  /// 5. Remove duplicados e filtra precisamente por bounds.
  ///
  /// Isso resolve o problema da abordagem single-range, que falha quando
  /// o viewport cruza múltiplos prefixos de geohash (ex.: centro-borda SP).
  ///
  /// Filtros aplicados aqui (datasource), não em memória:
  /// - tipos de alerta (se filtro ativo)
  /// - data (dateFrom/dateTo via query ou pós-filtro local)
  @override
  Future<List<AlertaModel>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  }) async {
    try {
      final ranges = GeoUtils.geohashRangesForBounds(bounds, zoom: zoom);

      if (ranges.isEmpty) {
        return [];
      }

      // Executa queries em paralelo (uma por range)
      final futures = ranges.map((range) => _queryRange(range, filter));
      final results = await Future.wait(futures);

      // Remove duplicados por ID e filtra precisamente por bounds
      final seen = <String>{};
      final alertas = <AlertaModel>[];
      for (final batch in results) {
        for (final alerta in batch) {
          if (seen.contains(alerta.id)) continue;
          if (!bounds.contains(alerta.latitude, alerta.longitude)) continue;
          seen.add(alerta.id);
          alertas.add(alerta);
        }
      }

      if (alertas.isEmpty) {
        debugPrint(
          '[AlertaDatasource] Nenhum alerta em ${ranges.length} ranges. '
          'Usando fallback.',
        );
        return _fallbackInBounds(bounds, filter);
      }

      return alertas;
    } catch (e) {
      debugPrint('[AlertaDatasource] Erro na query por bounds: $e');
      return _fallbackInBounds(bounds, filter);
    }
  }

  Future<List<AlertaModel>> _queryRange(
    GeoHashRange range,
    AlertaFilter filter,
  ) async {
    Query<Map<String, dynamic>> query = firestore
        .collection('alertas')
        .orderBy('geohash')
        .startAt([range.lower])
        .endAt([range.upper])
        .limit(_maxPerRange);

    // Filtro por tipo aplicado no Firestore quando possível
    if (filter.tipos.length == 1) {
      final tipo = filter.tipos.first;
      query = query.where('tipo', isEqualTo: tipo.label);
    }

    // Filtro de data inicial aplicado no Firestore
    if (filter.dateFrom != null) {
      query = query.where(
        'data',
        isGreaterThanOrEqualTo: Timestamp.fromDate(filter.dateFrom!),
      );
    }

    // Filtro de data final aplicado no Firestore
    if (filter.dateTo != null) {
      final endOfDay = DateTime(
        filter.dateTo!.year,
        filter.dateTo!.month,
        filter.dateTo!.day,
        23,
        59,
        59,
      );
      query = query.where(
        'data',
        isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
      );
    }

    final snapshot = await query.get();
    var results = snapshot.docs.map(AlertaModel.fromFirestore).toList();

    // Filtro em memória para múltiplos tipos (Firestore não suporta whereIn
    // combinado com orderBy de campo diferente sem índice composto)
    if (filter.tipos.length > 1) {
      final allowedLabels = filter.tipos.map((t) => t.label).toSet();
      results = results
          .where((a) => allowedLabels.contains(a.tipo.label))
          .toList();
    }

    return results;
  }

  /// Fallback para coleções pequenas ou quando geohash não está indexado.
  ///
  /// AVISO: este fallback NÃO deve ser acionado em produção com > 5k docs.
  /// Configure o índice de geohash no Firestore antes do lançamento.
  Future<List<AlertaModel>> _fallbackInBounds(
    GeoBounds bounds,
    AlertaFilter filter,
  ) async {
    final all = await getAlertas();
    return all.where((alerta) {
      if (!bounds.contains(alerta.latitude, alerta.longitude)) return false;
      if (filter.tipos.isNotEmpty && !filter.tipos.contains(alerta.tipo)) {
        return false;
      }
      if (filter.dateFrom != null && alerta.data.isBefore(filter.dateFrom!)) {
        return false;
      }
      if (filter.dateTo != null && alerta.data.isAfter(filter.dateTo!)) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }
}
