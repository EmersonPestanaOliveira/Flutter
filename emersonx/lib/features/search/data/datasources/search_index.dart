import 'package:flutter/material.dart';
import '../../domain/entities/search_result.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../design_system/tokens/app_colors.dart';

abstract final class SearchIndex {
  static const all = <SearchResult>[
    // --- Core ---
    SearchResult(
      id: 'settings',
      title: 'Configuracoes',
      subtitle: 'Tema, idioma, escala de texto, modo dev',
      route: AppRoutes.settings,
      icon: Icons.settings_outlined,
      color: AppColors.neutral600,
      breadcrumb: 'App / Configuracoes',
    ),
    SearchResult(
      id: 'about',
      title: 'Sobre o App',
      subtitle: 'Versao, stack, creditos, licencas',
      route: AppRoutes.about,
      icon: Icons.info_outline,
      color: AppColors.neutral600,
      breadcrumb: 'App / Sobre',
    ),
    // --- Design System ---
    SearchResult(
      id: 'design_system',
      title: 'Design System',
      subtitle: 'Catalogo de componentes e tokens',
      route: AppRoutes.designSystem,
      icon: Icons.palette_outlined,
      color: AppColors.moduleDesignSystem,
      breadcrumb: 'Modulos / Design System',
    ),
    // --- Layout ---
    SearchResult(
      id: 'layout',
      title: 'Layout e Responsividade',
      subtitle: 'AdaptiveLayout, Grid, Slivers, Flex',
      route: AppRoutes.layout,
      icon: Icons.dashboard_outlined,
      color: AppColors.moduleLayout,
      breadcrumb: 'Modulos / Layout',
    ),
    // --- Animacoes ---
    SearchResult(
      id: 'animations',
      title: 'Animacoes',
      subtitle: 'Implicit, Explicit, Hero, Rive, Lottie',
      route: AppRoutes.animations,
      icon: Icons.animation_outlined,
      color: AppColors.moduleAnimations,
      breadcrumb: 'Modulos / Animacoes',
    ),
    // --- Acessibilidade ---
    SearchResult(
      id: 'accessibility',
      title: 'Acessibilidade',
      subtitle: 'Semantics, TalkBack, contraste, A11y',
      route: AppRoutes.accessibility,
      icon: Icons.accessibility_new_outlined,
      color: AppColors.moduleAccessibility,
      breadcrumb: 'Modulos / Acessibilidade',
    ),
    // --- Multimidia ---
    SearchResult(
      id: 'multimedia',
      title: 'Multimidia',
      subtitle: 'Camera, audio, video, galeria',
      route: AppRoutes.multimedia,
      icon: Icons.perm_media_outlined,
      color: AppColors.moduleMultimedia,
      breadcrumb: 'Modulos / Multimidia',
    ),
    // --- Maps ---
    SearchResult(
      id: 'maps',
      title: 'Maps',
      subtitle: 'Google Maps, geolocalizacao, geocoding',
      route: AppRoutes.maps,
      icon: Icons.map_outlined,
      color: AppColors.moduleMaps,
      breadcrumb: 'Modulos / Maps',
    ),
    // --- Sensores ---
    SearchResult(
      id: 'sensors',
      title: 'Sensores',
      subtitle: 'Acelerometro, giroscopio, bussola, luz',
      route: AppRoutes.sensors,
      icon: Icons.sensors_outlined,
      color: AppColors.moduleSensors,
      breadcrumb: 'Modulos / Sensores',
    ),
    // --- Conectividade ---
    SearchResult(
      id: 'connectivity',
      title: 'Conectividade',
      subtitle: 'Bluetooth, WiFi, NFC, WebSocket',
      route: AppRoutes.connectivity,
      icon: Icons.wifi_outlined,
      color: AppColors.moduleConnectivity,
      breadcrumb: 'Modulos / Conectividade',
    ),
    // --- Social ---
    SearchResult(
      id: 'social',
      title: 'Social e Auth',
      subtitle: 'Login, Google Sign-In, perfil, share',
      route: AppRoutes.social,
      icon: Icons.people_outline,
      color: AppColors.moduleSocial,
      breadcrumb: 'Modulos / Social',
    ),
    // --- Regional ---
    SearchResult(
      id: 'regional',
      title: 'Regionalizacao',
      subtitle: 'i18n PT/EN/ES/JA, formatos, RTL',
      route: AppRoutes.regional,
      icon: Icons.language_outlined,
      color: AppColors.moduleRegional,
      breadcrumb: 'Modulos / Regionalizacao',
    ),
    // --- Rotas ---
    SearchResult(
      id: 'routing',
      title: 'Rotas e Transicoes',
      subtitle: 'GoRouter, transicoes, deep links, guards',
      route: AppRoutes.routing,
      icon: Icons.route_outlined,
      color: AppColors.moduleRouting,
      breadcrumb: 'Modulos / Rotas',
    ),
    // --- DI ---
    SearchResult(
      id: 'di',
      title: 'Injecao de Dependencia',
      subtitle: 'get_it, injectable, scopes, lifetimes',
      route: AppRoutes.di,
      icon: Icons.hub_outlined,
      color: AppColors.moduleDI,
      breadcrumb: 'Modulos / DI',
    ),
    // --- IA ---
    SearchResult(
      id: 'ai',
      title: 'Inteligencia Artificial',
      subtitle: 'Gemini, visao computacional, TTS, STT',
      route: AppRoutes.ai,
      icon: Icons.smart_toy_outlined,
      color: AppColors.moduleAI,
      breadcrumb: 'Modulos / IA',
    ),
    // --- Testes ---
    SearchResult(
      id: 'testing',
      title: 'Testes',
      subtitle: 'Unit, Widget, Integration, Coverage',
      route: AppRoutes.testing,
      icon: Icons.bug_report_outlined,
      color: AppColors.moduleTesting,
      breadcrumb: 'Modulos / Testes',
    ),
  ];
}