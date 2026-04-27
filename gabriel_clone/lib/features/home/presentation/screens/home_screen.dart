import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_bottom_nav.dart';
import '../../../../core/design_system/components/app_button.dart';
import '../../../../core/design_system/components/app_error_widget.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/screen_utils.dart';
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
    final horizontalPadding = ScreenUtils.horizontalPadding(context);
    final bottomPadding = ScreenUtils.bottomOverlayPadding(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
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
                Positioned(
                  top: topPadding + AppSpacing.xl,
                  left: horizontalPadding,
                  child: _MapCircleButton(
                    icon: Icons.menu,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menu em breve')),
                      );
                    },
                  ),
                ),
                if (loadedState != null)
                  Positioned(
                    top: topPadding + AppSpacing.xl,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: HomeTabBar(tabIndex: loadedState.tabIndex),
                    ),
                  ),
                Positioned(
                  left: horizontalPadding,
                  bottom: bottomPadding + 118,
                  child: _MapCircleButton(
                    icon: Icons.my_location,
                    onPressed: _goToCurrentLocation,
                  ),
                ),
                Positioned(
                  right: horizontalPadding,
                  bottom: bottomPadding + 118,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width < 430 ? 220 : 340,
                      height: 56,
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
      ),
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

class _MapCircleButton extends StatelessWidget {
  const _MapCircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutral0,
      shape: const CircleBorder(),
      elevation: 8,
      shadowColor: const Color(0x33000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 56,
          child: Icon(icon, color: AppColors.headerBlue, size: 32),
        ),
      ),
    );
  }
}