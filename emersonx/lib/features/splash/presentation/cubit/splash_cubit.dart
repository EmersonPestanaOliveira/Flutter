import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initialize() async {
    emit(SplashLoading());
    // Aguarda o minimo para exibir a animacao
    await Future.delayed(const Duration(milliseconds: 2200));
    // TODO: verificar auth, carregar configs, inicializar DI
    emit(SplashReady());
  }
}