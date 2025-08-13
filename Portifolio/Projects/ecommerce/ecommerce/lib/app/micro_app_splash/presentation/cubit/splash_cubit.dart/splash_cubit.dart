import 'package:ecommerce/app/micro_app_splash/presentation/cubit/splash_state.dart/splash_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init() async {
    emit(SplashLoading());

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula carregamento

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    } catch (_) {
      emit(SplashError());
    }
  }
}
