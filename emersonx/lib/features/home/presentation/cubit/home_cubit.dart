import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/feature_module.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../../../core/router/app_routes.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> loadModules() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(HomeLoaded(_modules));
  }

  static const _modules = [
    FeatureModule(
      id: 'design_system',
      title: 'Design System',
      subtitle: 'Tokens, componentes, tema',
      route: AppRoutes.designSystem,
      icon: Icons.palette_outlined,
      color: AppColors.moduleDesignSystem,
      isReady: false,
    ),
    FeatureModule(
      id: 'layout',
      title: 'Layout',
      subtitle: 'Responsividade, Slivers, Grid',
      route: AppRoutes.layout,
      icon: Icons.dashboard_outlined,
      color: AppColors.moduleLayout,
      isReady: false,
    ),
    FeatureModule(
      id: 'animations',
      title: 'Animacoes',
      subtitle: 'Implicit, Explicit, Hero',
      route: AppRoutes.animations,
      icon: Icons.animation_outlined,
      color: AppColors.moduleAnimations,
      isReady: false,
    ),
    FeatureModule(
      id: 'accessibility',
      title: 'Acessibilidade',
      subtitle: 'Semantics, TalkBack, A11y',
      route: AppRoutes.accessibility,
      icon: Icons.accessibility_new_outlined,
      color: AppColors.moduleAccessibility,
      isReady: false,
    ),
    FeatureModule(
      id: 'multimedia',
      title: 'Multimidia',
      subtitle: 'Camera, audio, video',
      route: AppRoutes.multimedia,
      icon: Icons.perm_media_outlined,
      color: AppColors.moduleMultimedia,
      isReady: false,
    ),
    FeatureModule(
      id: 'maps',
      title: 'Maps',
      subtitle: 'Google Maps, geolocalizacao',
      route: AppRoutes.maps,
      icon: Icons.map_outlined,
      color: AppColors.moduleMaps,
      isReady: false,
    ),
    FeatureModule(
      id: 'sensors',
      title: 'Sensores',
      subtitle: 'Acelerometro, GPS, bussola',
      route: AppRoutes.sensors,
      icon: Icons.sensors_outlined,
      color: AppColors.moduleSensors,
      isReady: false,
    ),
    FeatureModule(
      id: 'connectivity',
      title: 'Conectividade',
      subtitle: 'Bluetooth, WiFi, NFC',
      route: AppRoutes.connectivity,
      icon: Icons.wifi_outlined,
      color: AppColors.moduleConnectivity,
      isReady: false,
    ),
    FeatureModule(
      id: 'social',
      title: 'Social',
      subtitle: 'Auth, Google, perfil',
      route: AppRoutes.social,
      icon: Icons.people_outline,
      color: AppColors.moduleSocial,
      isReady: false,
    ),
    FeatureModule(
      id: 'regional',
      title: 'Regionalizacao',
      subtitle: 'i18n PT/EN/ES/JA, RTL',
      route: AppRoutes.regional,
      icon: Icons.language_outlined,
      color: AppColors.moduleRegional,
      isReady: false,
    ),
    FeatureModule(
      id: 'routing',
      title: 'Rotas',
      subtitle: 'GoRouter, transicoes, guards',
      route: AppRoutes.routing,
      icon: Icons.route_outlined,
      color: AppColors.moduleRouting,
      isReady: false,
    ),
    FeatureModule(
      id: 'di',
      title: 'Injecao de Dep.',
      subtitle: 'get_it, injectable, scopes',
      route: AppRoutes.di,
      icon: Icons.hub_outlined,
      color: AppColors.moduleDI,
      isReady: false,
    ),
    FeatureModule(
      id: 'ai',
      title: 'Inteligencia Artificial',
      subtitle: 'Gemini, visao, TTS, STT',
      route: AppRoutes.ai,
      icon: Icons.smart_toy_outlined,
      color: AppColors.moduleAI,
      isReady: false,
    ),
    FeatureModule(
      id: 'testing',
      title: 'Testes',
      subtitle: 'Unit, Widget, Integration',
      route: AppRoutes.testing,
      icon: Icons.bug_report_outlined,
      color: AppColors.moduleTesting,
      isReady: false,
    ),
  ];
}