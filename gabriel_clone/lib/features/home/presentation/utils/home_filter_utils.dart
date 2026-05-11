import '../../../../core/utils/text_normalizer.dart';
import '../../../../core/geo/geo_utils.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../cubit/home_state.dart';
import 'home_date_utils.dart';

List<Camera> applyCameraFilters(
  List<Camera> cameras, {
  required String query,
  required String? bairro,
  required String? cidade,
  required String? regiao,
}) {
  final normalizedQuery = normalizeSearchText(query);

  return cameras
      .where((camera) {
        if (normalizedQuery.isNotEmpty) {
          final streetText = normalizeSearchText(
            '${camera.rua} ${camera.nome}',
          );
          if (!streetText.contains(normalizedQuery)) {
            return false;
          }
        }

        if (bairro != null && camera.bairro != bairro) {
          return false;
        }
        if (cidade != null && camera.cidade != cidade) {
          return false;
        }
        if (regiao != null && camera.regiao != regiao) {
          return false;
        }

        return true;
      })
      .toList(growable: false);
}

List<Alerta> applyAlertFilters(
  List<Alerta> alertas, {
  required String query,
  required String? bairro,
  required String? cidade,
  required AlertaTipo? tipo,
  Object? dateKey,
}) {
  final normalizedQuery = normalizeSearchText(query);

  return alertas
      .where((alerta) {
        if (normalizedQuery.isNotEmpty) {
          final searchable = normalizeSearchText(
            '${alerta.bairro} ${alerta.cidade} '
            '${alerta.tipo.label} ${formatHomeDate(alerta.data)}',
          );
          if (!searchable.contains(normalizedQuery)) {
            return false;
          }
        }

        if (bairro != null && alerta.bairro != bairro) {
          return false;
        }
        if (cidade != null && alerta.cidade != cidade) {
          return false;
        }
        if (tipo != null && alerta.tipo != tipo) {
          return false;
        }

        return true;
      })
      .toList(growable: false);
}

// ---------------------------------------------------------------------------
// Filtro de domínio — função pura testável
// ---------------------------------------------------------------------------

/// Aplica um [AlertaFilter] a uma lista de [Alerta] e retorna os que passam.
///
/// Função pura: sem side-effects, facilmente testável em isolamento.
List<Alerta> applyFilter(List<Alerta> alertas, AlertaFilter filter) {
  if (filter.isEmpty) return alertas;

  return alertas
      .where((alerta) {
        // Filtro por tipo — conjunto vazio significa "todos"
        if (filter.tipos.isNotEmpty && !filter.tipos.contains(alerta.tipo)) {
          return false;
        }

        // Filtro por data inicial (inclusive)
        if (filter.dateFrom != null) {
          final from = DateTime(
            filter.dateFrom!.year,
            filter.dateFrom!.month,
            filter.dateFrom!.day,
          );
          final alertDate = DateTime(
            alerta.data.year,
            alerta.data.month,
            alerta.data.day,
          );
          if (alertDate.isBefore(from)) return false;
        }

        // Filtro por data final (inclusive)
        if (filter.dateTo != null) {
          final to = DateTime(
            filter.dateTo!.year,
            filter.dateTo!.month,
            filter.dateTo!.day,
          );
          final alertDate = DateTime(
            alerta.data.year,
            alerta.data.month,
            alerta.data.day,
          );
          if (alertDate.isAfter(to)) return false;
        }

        if (filter.radius != null &&
            filter.centerLatitude != null &&
            filter.centerLongitude != null) {
          final distanceKm = GeoUtils.distanceKm(
            filter.centerLatitude!,
            filter.centerLongitude!,
            alerta.latitude,
            alerta.longitude,
          );
          if (distanceKm > filter.radius!) return false;
        }

        return true;
      })
      .toList(growable: false);
}

String homePinsKey({
  required HomeLoaded state,
  required List<Camera> cameras,
  required List<Alerta> alertas,
}) {
  final visibleAlertCount = state.isAlertMapEnabled ? alertas.length : 0;
  final cameraHash = Object.hashAll(
    cameras.map(
      (camera) => Object.hash(camera.id, camera.latitude, camera.longitude),
    ),
  );
  final alertHash = state.isAlertMapEnabled
      ? Object.hashAll(
          alertas.map(
            (alerta) => Object.hash(
              alerta.id,
              alerta.tipo,
              alerta.latitude,
              alerta.longitude,
            ),
          ),
        )
      : 0;

  return [
    state.tabIndex,
    cameras.length,
    visibleAlertCount,
    cameraHash,
    alertHash,
    state.isAlertMapEnabled,
  ].join(':');
}
