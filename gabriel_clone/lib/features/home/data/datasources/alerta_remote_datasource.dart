import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/geo/geo_utils.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../../../core/observability/telemetry.dart';
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
  const AlertaRemoteDatasourceImpl(this.firestore, {Telemetry? telemetry})
      : _telemetry = telemetry;

  final FirebaseFirestore firestore;
  final Telemetry? _telemetry;

  /// Tamanho da pagina por range. O range e paginado ate acabar, para nao
  /// truncar pins em areas densas.
  static const int _pageSize = 500;

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

  /// Busca alertas no viewport usando multiplos geohash ranges.
  ///
  /// Estrategia multi-range:
  /// 1. Enumera celulas geohash que cobrem todo o viewport.
  /// 2. Reduz precisao quando a area geraria ranges demais.
  /// 3. Consolida em ranges [lower, upper] continuos.
  /// 4. Executa uma query Firestore por range em paralelo e pagina cada range.
  /// 5. Remove duplicados e filtra precisamente por bounds.
  ///
  /// Isso resolve o problema da abordagem single-range, que falha quando
  /// o viewport cruza multiplos prefixos de geohash (ex.: centro-borda SP).
  ///
  /// Filtros aplicados aqui (datasource), não em memória:
  /// - tipo unico de alerta, quando filtro ativo
  /// - data em memoria, depois do corte espacial por geohash
  @override
  Future<List<AlertaModel>> getAlertasInBounds({
    required GeoBounds bounds,
    required AlertaFilter filter,
    required double zoom,
  }) async {
    var rangeCount = 0;
    try {
      final ranges = GeoUtils.geohashRangesForBounds(bounds, zoom: zoom);
      rangeCount = ranges.length;
      _telemetry?.log('map.geohash_ranges_built', params: {
        'rangeCount': ranges.length,
        'zoom': zoom.toStringAsFixed(1),
      });

      if (ranges.isEmpty) {
        return [];
      }

      // Executa queries em paralelo (uma por range), com paginacao interna.
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

      return alertas;
    } catch (e) {
      final missingIndex = _isMissingIndexError(e);
      if (missingIndex) {
        _telemetry?.log(
          'missing_firestore_index',
          params: _queryTelemetryParams(
            filter: filter,
            rangeCount: rangeCount,
          ),
        );
      }
      _logViewportQueryFailed(
        reason: missingIndex ? 'missing_firestore_index' : 'query_error',
        filter: filter,
        rangeCount: rangeCount,
        errorType: e.runtimeType.toString(),
      );
      debugPrint('[AlertaDatasource] Erro na query por bounds: $e');
      throw BackendErrorMapper.toFailure(e);
    }
  }

  bool _isMissingIndexError(Object error) {
    if (error is FirebaseException && error.code == 'failed-precondition') {
      return true;
    }
    final message = error.toString().toLowerCase();
    return message.contains('index') || message.contains('failed-precondition');
  }

  void _logViewportQueryFailed({
    required String reason,
    required AlertaFilter filter,
    required int rangeCount,
    String? errorType,
  }) {
    final params = _queryTelemetryParams(
      filter: filter,
      rangeCount: rangeCount,
    );
    final eventParams = {...params, 'reason': reason};
    if (errorType != null) {
      eventParams['errorType'] = errorType;
    }
    _telemetry?.log('map.viewport_query_failed', params: eventParams);
  }

  Map<String, Object?> _queryTelemetryParams({
    required AlertaFilter filter,
    required int rangeCount,
  }) {
    return {
      'collection': 'alertas',
      'rangeCount': rangeCount,
      'hasTypeFilter': filter.tipos.isNotEmpty,
      'typeFilterCount': filter.tipos.length,
      'hasDateFilter': filter.dateFrom != null || filter.dateTo != null,
      'hasDateFrom': filter.dateFrom != null,
      'hasDateTo': filter.dateTo != null,
    };
  }

  Future<List<AlertaModel>> _queryRange(
    GeoHashRange range,
    AlertaFilter filter,
  ) async {
    Query<Map<String, dynamic>> baseQuery = firestore
        .collection('alertas')
        .orderBy('geohash')
        .startAt([range.lower])
        .endAt([range.upper])
        .limit(_pageSize);

    // Filtro por tipo aplicado no Firestore quando possível
    if (filter.tipos.length == 1) {
      final tipo = filter.tipos.first;
      baseQuery = baseQuery.where('tipo', isEqualTo: tipo.label);
    }

    final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;
    while (true) {
      final query = lastDoc == null
          ? baseQuery
          : baseQuery.startAfterDocument(lastDoc);
      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) break;

      docs.addAll(snapshot.docs);
      if (snapshot.docs.length < _pageSize) break;
      lastDoc = snapshot.docs.last;
    }

    var results = docs.map(AlertaModel.fromFirestore).toList();

    // Filtro em memória para múltiplos tipos (Firestore não suporta whereIn
    // combinado com orderBy de campo diferente sem índice composto)
    if (filter.tipos.length > 1) {
      final allowedLabels = filter.tipos.map((t) => t.label).toSet();
      results = results
          .where((a) => allowedLabels.contains(a.tipo.label))
          .toList();
    }

    if (filter.dateFrom != null) {
      results = results
          .where((a) => !a.data.isBefore(filter.dateFrom!))
          .toList();
    }

    if (filter.dateTo != null) {
      final endOfDay = DateTime(
        filter.dateTo!.year,
        filter.dateTo!.month,
        filter.dateTo!.day,
        23,
        59,
        59,
      );
      results = results.where((a) => !a.data.isAfter(endOfDay)).toList();
    }

    return results;
  }

}
