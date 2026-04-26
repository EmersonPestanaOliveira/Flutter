import 'package:equatable/equatable.dart';

import '../../domain/entities/camera_location.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.cameras = const [],
    this.errorMessage,
  });

  const HomeState.initial() : this(status: HomeStatus.initial);

  const HomeState.loading() : this(status: HomeStatus.loading);

  const HomeState.loaded(List<CameraLocation> cameras)
      : this(status: HomeStatus.loaded, cameras: cameras);

  const HomeState.failure(String message)
      : this(status: HomeStatus.failure, errorMessage: message);

  final HomeStatus status;
  final List<CameraLocation> cameras;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, cameras, errorMessage];
}