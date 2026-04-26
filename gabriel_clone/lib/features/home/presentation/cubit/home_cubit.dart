import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure_x.dart';
import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';
import '../../domain/usecases/get_alertas_usecase.dart';
import '../../domain/usecases/get_cameras_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.getCamerasUseCase, this.getAlertasUseCase)
      : super(const HomeInitial());

  final GetCamerasUseCase getCamerasUseCase;
  final GetAlertasUseCase getAlertasUseCase;

  Future<void> loadData() async {
    emit(const HomeLoading());

    final results = await Future.wait([
      getCamerasUseCase(const NoParams()),
      getAlertasUseCase(const NoParams()),
    ]);

    final camerasResult = results[0] as AppResult<List<Camera>>;
    final alertasResult = results[1] as AppResult<List<Alerta>>;

    camerasResult.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (cameras) => alertasResult.fold(
        (failure) => emit(HomeError(message: failure.message)),
        (alertas) => emit(
          HomeLoaded(
            cameras: cameras,
            alertas: alertas,
          ),
        ),
      ),
    );
  }

  void changeTab(int index) {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    emit(currentState.copyWith(tabIndex: index));
  }
}