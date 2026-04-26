import 'package:equatable/equatable.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.cameras,
    required this.alertas,
    this.tabIndex = 0,
  });

  final List<Camera> cameras;
  final List<Alerta> alertas;
  final int tabIndex;

  HomeLoaded copyWith({
    List<Camera>? cameras,
    List<Alerta>? alertas,
    int? tabIndex,
  }) {
    return HomeLoaded(
      cameras: cameras ?? this.cameras,
      alertas: alertas ?? this.alertas,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [cameras, alertas, tabIndex];
}

final class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}