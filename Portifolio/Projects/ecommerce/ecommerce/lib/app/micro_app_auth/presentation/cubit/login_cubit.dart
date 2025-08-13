import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _auth = FirebaseAuth.instance;
  final _google =
      GoogleSignIn(); // se precisar de authCode, passe serverClientId

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      print('[LOGIN/EMAIL] tentando login para $email');
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw Exception('Timeout no signInWithEmailAndPassword');
            },
          );

      print('[LOGIN/EMAIL] sucesso');
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      final msg = _mapFirebaseAuthError(e);
      print('[LOGIN/EMAIL][FIREBASE] $e (${e.code})');
      emit(LoginError(msg));
    } catch (e, s) {
      print('[LOGIN/EMAIL][ERRO] $e\n$s');
      emit(LoginError('Falha no login: $e'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      print('[LOGIN/GOOGLE] iniciando fluxo GoogleSignIn');
      final acc = await _google.signIn();
      print('[LOGIN/GOOGLE] resultado signIn: $acc');

      if (acc == null) {
        emit(
          LoginError(
            'Login cancelado ou falhou. Verifique conta Google e SHA-1/SHA-256 no Firebase.',
          ),
        );
        return;
      }

      final auth = await acc.authentication;
      print(
        '[LOGIN/GOOGLE] tokens -> accessToken? ${auth.accessToken != null}, idToken? ${auth.idToken != null}',
      );

      if (auth.idToken == null) {
        emit(
          LoginError(
            'Falha ao obter idToken do Google (geralmente SHA-1/SHA-256 ausentes no Firebase).',
          ),
        );
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCred = await _auth
          .signInWithCredential(credential)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw Exception('Timeout no signInWithCredential');
            },
          );

      print('[LOGIN/GOOGLE] FirebaseAuth OK: ${userCred.user?.uid}');
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      final msg = _mapFirebaseAuthError(e);
      print('[LOGIN/GOOGLE][FIREBASE] $e (${e.code})');
      emit(LoginError(msg));
    } catch (e, s) {
      print('[LOGIN/GOOGLE][ERRO] $e\n$s');
      emit(LoginError('Erro ao entrar com o Google: $e'));
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'account-exists-with-different-credential':
        return 'Já existe conta com outro método de login.';
      case 'network-request-failed':
        return 'Falha de rede. Tente novamente.';
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        return 'Código/verificação inválidos.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'operation-not-allowed':
        return 'Método de login desativado no Firebase.';
      default:
        return 'Erro de autenticação (${e.code}).';
    }
  }
}
