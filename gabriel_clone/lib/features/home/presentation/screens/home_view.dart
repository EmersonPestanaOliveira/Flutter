import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/design_system/components/app_bottom_nav.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/entities/camera.dart';
import '../controllers/home_filter_state.dart';
import '../controllers/home_pin_readiness.dart';
import '../controllers/home_view_data.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../services/home_location_service.dart';
import '../services/home_preferences.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_filter_sheets.dart';
import '../widgets/home_help_sheet.dart';
import '../widgets/home_map_content.dart';

part 'home_view_actions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _streetSearchController = TextEditingController();
  final _alertSearchController = TextEditingController();
  final _preferences = HomePreferences();
  final _pinReadiness = HomePinReadiness();

  GoogleMapController? _mapController;
  HomeFilterState _filters = const HomeFilterState();
  bool _didLoadPreferences = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _streetSearchController.dispose();
    _alertSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ScreenUtils.horizontalPadding(context);
    final bottomPadding = ScreenUtils.bottomOverlayPadding(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawer: BlocBuilder<HomeCubit, HomeState>(builder: _buildDrawer),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final data = buildHomeViewData(state, _filters);
            final showLoading = _pinReadiness.shouldShowLoading(
              didLoadPreferences: _didLoadPreferences,
              state: state,
              loadedState: data.loadedState,
              pinsKey: data.pinsKey,
            );

            _pinReadiness.scheduleFallback(
              state: this,
              loadedState: data.loadedState,
              onReady: () => setState(() {}),
            );

            return HomeMapContent(
              state: state,
              loadedState: data.loadedState,
              cameras: data.cameras,
              alertas: data.alertas,
              canRenderPins: _didLoadPreferences && data.loadedState != null,
              showLoading: showLoading,
              horizontalPadding: horizontalPadding,
              bottomPadding: bottomPadding,
              topPadding: topPadding,
              streetSearchController: _streetSearchController,
              alertSearchController: _alertSearchController,
              hasActiveCameraFilters: _filters.hasActiveCameraFilters,
              hasActiveAlertFilters: _filters.hasActiveAlertFilters,
              onMapCreated: _onMapCreated,
              onCameraIdle: _onCameraIdle,
              onPinsReady: data.pinsKey == null
                  ? null
                  : () => _onPinsReady(data.pinsKey!),
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onCameraSearchChanged: _updateCameraQuery,
              onAlertSearchChanged: _updateAlertQuery,
              onClearCameraFilters: _clearCameraFilters,
              onClearAlertFilters: _clearAlertFilters,
              onCameraFiltersPressed: () => _openCameraFilters(data.cameras),
              onAlertFiltersPressed: () => _openAlertFilters(data.alertas),
              onCurrentLocationPressed: _goToCurrentLocation,
              onHelpPressed: () => showHomeHelpOptions(context),
              onRetry: context.read<HomeCubit>().loadData,
              onAlertRetry: _retryMapOcorrencia,
            );
          },
        ),
        bottomNavigationBar: const AppBottomNav(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, HomeState state) {
    final loadedState = state is HomeLoaded ? state : null;
    return HomeDrawer(
      isAlertMapVisible: loadedState?.isAlertMapEnabled ?? true,
      onAlertMapChanged: (value) {
        _preferences.saveAlertMapEnabled(value);
        context.read<HomeCubit>().setAlertMapEnabled(value);
        _markPinsDirty();
      },
    );
  }
}
