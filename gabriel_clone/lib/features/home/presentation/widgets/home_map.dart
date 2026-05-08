import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/observability/telemetry.dart';
import '../../danger_zones/data/danger_zone_location_monitor.dart';
import '../../danger_zones/data/danger_zone_service.dart';
import '../../danger_zones/presentation/danger_zone_map_layer.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_cluster.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../../domain/services/alerta_cluster_service.dart';
import 'home_marker_factory.dart';
import 'home_map_constants.dart';
import 'home_map_view.dart';
import 'home_pin_loader.dart';
import 'pin_cache.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({
    required this.cameras,
    required this.alertas,
    this.alertClusters,
    required this.dangerZoneAlertas,
    required this.tabIndex,
    this.onMapCreated,
    this.onCameraIdle,
    this.onPinsReady,
    this.onAlertRetry,
    super.key,
  });

  final List<Camera> cameras;
  final List<Alerta> alertas;
  final List<AlertaCluster>? alertClusters;
  final List<Alerta> dangerZoneAlertas;
  final int tabIndex;
  final void Function(GoogleMapController controller)? onMapCreated;
  final void Function(LatLngBounds bounds, double zoom)? onCameraIdle;
  final VoidCallback? onPinsReady;
  final Future<bool> Function(Alerta alerta)? onAlertRetry;

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  BitmapDescriptor? _cameraPinIcon;
  final Map<AlertaTipo, BitmapDescriptor> _alertPinIcons = {};
  final DangerZoneService _dangerZoneService = sl<DangerZoneService>();
  final DangerZoneLocationMonitor _dangerZoneLocationMonitor =
      sl<DangerZoneLocationMonitor>();
  final Telemetry? _telemetry = sl.isRegistered<Telemetry>()
      ? sl<Telemetry>()
      : null;
  GoogleMapController? _mapController;
  Set<Marker> _cameraMarkers = const {};
  Set<Marker> _alertMarkers = const {};
  Set<Circle> _dangerZoneCircles = const {};
  bool _isCameraPinReady = false;
  bool _areAlertPinIconsReady = false;
  bool _didStartCameraIconLoad = false;
  bool _didStartAlertIconsLoad = false;
  int _dangerZoneLoadToken = 0;
  int _alertMarkerBuildToken = 0;
  double _currentZoom = HomeMapConstants.initialZoom;
  Alerta? _selectedAlert;

  @override
  void initState() {
    super.initState();
    _loadCameraPinIcon();
    _loadAlertPinIcons();
    _loadDangerZones();
  }

  @override
  void didUpdateWidget(covariant HomeMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final camerasChanged = !listEquals(oldWidget.cameras, widget.cameras);
    final alertasChanged = !listEquals(oldWidget.alertas, widget.alertas);
    final dangerZoneAlertasChanged = !listEquals(
      oldWidget.dangerZoneAlertas,
      widget.dangerZoneAlertas,
    );
    final tabChanged = oldWidget.tabIndex != widget.tabIndex;

    if (tabChanged && widget.tabIndex != 1) {
      _selectedAlert = null;
    }

    if (camerasChanged) {
      _cameraMarkers = _buildCameraMarkers();
    }

    final clustersChanged = !listEquals(
      oldWidget.alertClusters,
      widget.alertClusters,
    );

    if (alertasChanged ||
        clustersChanged ||
        (tabChanged && widget.tabIndex == 1)) {
      _rebuildAlertMarkers();
    }

    if (dangerZoneAlertasChanged) {
      _loadDangerZones();
    }

    _notifyPinsReadyIfPossible();
  }

  @override
  void dispose() {
    _dangerZoneLocationMonitor.stop();
    super.dispose();
  }

  Future<void> _loadCameraPinIcon() async {
    if (_didStartCameraIconLoad) {
      return;
    }
    _didStartCameraIconLoad = true;

    final icon = await HomePinLoader.cameraPin();

    if (!mounted) {
      return;
    }

    setState(() {
      _cameraPinIcon = icon;
      _isCameraPinReady = true;
    });
    _rebuildCameraMarkers();
    _notifyPinsReadyIfPossible();
  }

  Future<void> _loadAlertPinIcons() async {
    if (_didStartAlertIconsLoad) {
      return;
    }
    _didStartAlertIconsLoad = true;

    Map<AlertaTipo, BitmapDescriptor> icons = const {};
    try {
      icons = await HomePinLoader.alertPins();
    } catch (_) {}

    if (!mounted) {
      return;
    }

    setState(() {
      _alertPinIcons
        ..clear()
        ..addAll(icons);
      _areAlertPinIconsReady = true;
    });
    PinCache.storeAlertPins(icons);
    _rebuildAlertMarkers();
    _notifyPinsReadyIfPossible();
  }

  Set<Marker> _buildCameraMarkers() {
    return widget.cameras
        .map(
          (camera) =>
              HomeMarkerFactory.camera(camera: camera, icon: _cameraPinIcon),
        )
        .toSet();
  }

  void _rebuildCameraMarkers() {
    if (!mounted) {
      return;
    }
    final markers = _buildCameraMarkers();
    setState(() {
      _cameraMarkers = markers;
    });
  }

  Future<void> _rebuildAlertMarkers() async {
    final token = ++_alertMarkerBuildToken;
    final start = DateTime.now().millisecondsSinceEpoch;
    final markers = await _buildAlertMarkers();
    if (!mounted || token != _alertMarkerBuildToken) {
      return;
    }
    setState(() => _alertMarkers = markers);
    _telemetry?.log(
      'map.markers_rendered',
      params: {
        'markerCount': markers.length,
        'elapsedMs': DateTime.now().millisecondsSinceEpoch - start,
        'zoom': _currentZoom.toStringAsFixed(1),
      },
    );
    _notifyPinsReadyIfPossible();
  }

  Future<Set<Marker>> _buildAlertMarkers() async {
    final visibleAlertas = widget.alertas
        .where((alerta) => alerta.latitude != 0 && alerta.longitude != 0)
        .toList(growable: false);
    final clusterResult = widget.alertClusters == null
        ? AlertaClusterService.build(visibleAlertas, _currentZoom)
        : null;
    final clusters = widget.alertClusters ?? clusterResult!.clusters;

    if (clusterResult != null) {
      _telemetry?.log(
        'map.clusters_built',
        params: {
          'clusteringEnabled': clusterResult.enabled,
          'clusterDecisionReason': clusterResult.reason,
          'clusterCount': clusterResult.clusterCount,
          'individualPinCount': clusterResult.individualPinCount,
          'elapsedMs': clusterResult.elapsedMs,
          'pinCount': visibleAlertas.length,
        },
      );
    }

    final markers = await Future.wait(
      clusters.map(
        (cluster) => HomeMarkerFactory.alertaCluster(
          cluster: cluster,
          icons: _alertPinIcons,
          onPinTap: (alerta) => setState(() => _selectedAlert = alerta),
          onClusterTap: _zoomIntoCluster,
          telemetry: _telemetry,
        ),
      ),
    );

    return markers.toSet();
  }

  Future<void> _zoomIntoCluster(AlertaCluster cluster) async {
    final controller = _mapController;
    if (controller == null) return;
    final nextZoom = (_currentZoom + 2).clamp(3.0, 19.0).toDouble();
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(cluster.centerLatitude, cluster.centerLongitude),
        nextZoom,
      ),
    );
  }

  Future<void> _handleCameraIdle() async {
    final controller = _mapController;
    if (controller != null) {
      _currentZoom = await controller.getZoomLevel();
    }
    await _rebuildAlertMarkers();

    final callback = widget.onCameraIdle;
    if (callback == null || controller == null) {
      return;
    }

    final bounds = await controller.getVisibleRegion();
    callback(bounds, _currentZoom);
  }

  void _notifyPinsReadyIfPossible() {
    final pinsReady = widget.tabIndex == 0
        ? _isCameraPinReady
        : _areAlertPinIconsReady;
    if (!pinsReady) {
      return;
    }
    // Schedule the callback for the next frame so that we never call
    // setState() on the parent while the framework is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      widget.onPinsReady?.call();
    });
  }

  Future<void> _loadDangerZones() async {
    final token = ++_dangerZoneLoadToken;
    try {
      final result = await _dangerZoneService.loadZones(
        widget.dangerZoneAlertas,
      );
      if (!mounted || token != _dangerZoneLoadToken) {
        return;
      }

      final circles = result.config.enabled
          ? DangerZoneMapLayer.circlesFor(result.zones)
          : const <Circle>{};

      setState(() {
        _dangerZoneCircles = circles;
      });

      if (result.config.enabled && result.zones.isNotEmpty) {
        await _dangerZoneLocationMonitor.start(
          zones: result.zones,
          config: result.config,
        );
      } else {
        await _dangerZoneLocationMonitor.stop();
      }
    } catch (_) {
      if (!mounted || token != _dangerZoneLoadToken) {
        return;
      }
      setState(() {
        _dangerZoneCircles = const {};
      });
      await _dangerZoneLocationMonitor.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeMapView(
      tabIndex: widget.tabIndex,
      cameraMarkers: _cameraMarkers,
      alertMarkers: _alertMarkers,
      dangerZoneCircles: _dangerZoneCircles,
      selectedAlert: _selectedAlert,
      onAlertClose: () => setState(() => _selectedAlert = null),
      onAlertDeselect: () {
        if (_selectedAlert != null) {
          setState(() => _selectedAlert = null);
        }
      },
      onAlertRetry: _handleAlertRetry,
      onMapCreated: (controller) {
        _mapController = controller;
        widget.onMapCreated?.call(controller);
        _rebuildAlertMarkers();
        _notifyPinsReadyIfPossible();
      },
      onCameraMove: (position) => _currentZoom = position.zoom,
      onCameraIdle: _handleCameraIdle,
    );
  }

  Future<bool> _handleAlertRetry(Alerta alerta) async {
    final retry = widget.onAlertRetry;
    if (retry == null) {
      return false;
    }
    final didStartRetry = await retry(alerta);
    if (!mounted || !didStartRetry) {
      return didStartRetry;
    }
    if (_selectedAlert?.mergeKey == alerta.mergeKey) {
      setState(() {
        _selectedAlert = alerta.copyWith(
          localSyncStatus: 'queued',
          localError: null,
        );
      });
    }
    return didStartRetry;
  }
}
