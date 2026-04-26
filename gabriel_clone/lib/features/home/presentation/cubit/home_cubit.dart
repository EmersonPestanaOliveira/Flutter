import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/firebase_connection_validator.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_camera_locations.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.getCameraLocations, this.firebaseConnectionValidator)
      : super(const HomeState.initial());

  final GetCameraLocations getCameraLocations;
  final FirebaseConnectionValidator firebaseConnectionValidator;

  Future<void> loadCameraLocations() async {
    emit(const HomeState.loading());

    final result = await getCameraLocations(const NoParams());

    result.fold(
      (failure) => emit(HomeState.failure(failure.message)),
      (cameras) => emit(HomeState.loaded(cameras)),
    );
  }

  Future<void> createAndReadFirestoreTestDocument() async {
    emit(
      state.copyWith(
        isTestingFirestore: true,
        firestoreValidationMessage: 'Gravando e lendo documento de teste...',
      ),
    );

    try {
      await firebaseConnectionValidator.createAndReadTestDocument();
      emit(
        state.copyWith(
          hasFirestoreTestDocument: true,
          isTestingFirestore: false,
          firestoreValidationMessage:
              'Documento criado e lido. Confira _diagnostics/firestore_connection_test no Console.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isTestingFirestore: false,
          firestoreValidationMessage: 'Erro ao validar Firestore: $error',
        ),
      );
    }
  }

  Future<void> deleteFirestoreTestDocument() async {
    emit(
      state.copyWith(
        isTestingFirestore: true,
        firestoreValidationMessage: 'Removendo documento de teste...',
      ),
    );

    try {
      await firebaseConnectionValidator.deleteTestDocument();
      emit(
        state.copyWith(
          hasFirestoreTestDocument: false,
          isTestingFirestore: false,
          firestoreValidationMessage: 'Documento de teste removido.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isTestingFirestore: false,
          firestoreValidationMessage: 'Erro ao remover teste: $error',
        ),
      );
    }
  }
}