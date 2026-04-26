import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_bottom_nav.dart';
import '../../../../core/design_system/components/app_button.dart';
import '../../../../core/design_system/components/app_error_widget.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_map.dart';
import '../widgets/home_tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConfig.appName)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final loadedState = state is HomeLoaded ? state : null;

          return Stack(
            children: [
              Positioned.fill(
                child: HomeMap(
                  cameras: loadedState?.cameras ?? const [],
                  alertas: loadedState?.alertas ?? const [],
                  tabIndex: loadedState?.tabIndex ?? 0,
                  onMapCreated: (controller) => _mapController = controller,
                ),
              ),
              if (loadedState != null)
                Positioned(
                  top: AppSpacing.lg,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: Center(
                    child: HomeTabBar(tabIndex: loadedState.tabIndex),
                  ),
                ),
              Positioned(
                left: AppSpacing.lg,
                bottom: 88,
                child: FloatingActionButton.small(
                  heroTag: 'current_location_button',
                  onPressed: _goToCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ),
              Positioned(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                bottom: AppSpacing.xl,
                child: AppButton(
                  label: 'Pedir Ajuda',
                  leadingIcon: Icons.phone_in_talk_outlined,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Em breve')),
                    );
                  },
                ),
              ),
              if (state is HomeInitial || state is HomeLoading)
                const Positioned.fill(child: AppLoadingIndicator()),
              if (state is HomeError)
                Positioned.fill(
                  child: AppErrorWidget(
                    message: state.message,
                    onRetry: context.read<HomeCubit>().loadData,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Future<void> _goToCurrentLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = _mapController;

    if (controller == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Mapa ainda nao esta pronto.')),
      );
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Ative a localizacao do dispositivo.')),
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Permissao de localizacao negada.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15,
      ),
    );
  }
}