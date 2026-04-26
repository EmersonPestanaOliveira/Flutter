import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_camera_locations.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.getCameraLocations) : super(const HomeState.initial());

  final GetCameraLocations getCameraLocations;

  Future<void> loadCameraLocations() async {
    emit(const HomeState.loading());

    final result = await getCameraLocations();

    result.fold(
      (failure) => emit(HomeState.failure(failure.message)),
      (cameras) => emit(HomeState.loaded(cameras)),
    );
  }
}