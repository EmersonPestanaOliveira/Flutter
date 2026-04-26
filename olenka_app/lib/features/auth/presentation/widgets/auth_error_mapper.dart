import 'package:firebase_auth/firebase_auth.dart';

/// Traduz codigos de erro do Firebase Auth para portugues amigavel.
/// Compartilhado entre login, signup e forgot-password.
String mapAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'E-mail invalido.';
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'user-disabled':
        return 'Conta desabilitada. Contate o suporte.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail ja esta em uso.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexao com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Metodo de login nao habilitado no Firebase.';
      default:
        return 'Erro de autenticacao: ${error.code}';
    }
  }
  return 'Nao foi possivel completar a operacao.';
}