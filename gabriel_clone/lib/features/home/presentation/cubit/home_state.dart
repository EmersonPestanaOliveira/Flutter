import 'package:equatable/equatable.dart';

import '../../domain/entities/camera_location.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.cameras = const [],
    this.errorMessage,
    this.isTestingFirestore = false,
    this.hasFirestoreTestDocument = false,
    this.firestoreValidationMessage,
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
  final bool isTestingFirestore;
  final bool hasFirestoreTestDocument;
  final String? firestoreValidationMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<CameraLocation>? cameras,
    String? errorMessage,
    bool? isTestingFirestore,
    bool? hasFirestoreTestDocument,
    String? firestoreValidationMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      cameras: cameras ?? this.cameras,
      errorMessage: errorMessage ?? this.errorMessage,
      isTestingFirestore: isTestingFirestore ?? this.isTestingFirestore,
      hasFirestoreTestDocument:
          hasFirestoreTestDocument ?? this.hasFirestoreTestDocument,
      firestoreValidationMessage:
          firestoreValidationMessage ?? this.firestoreValidationMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cameras,
    errorMessage,
    isTestingFirestore,
    hasFirestoreTestDocument,
    firestoreValidationMessage,
  ];
}
