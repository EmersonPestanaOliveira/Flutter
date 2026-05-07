import 'package:firebase_auth/firebase_auth.dart';

User requireCurrentUser(
  FirebaseAuth firebaseAuth, {
  String message = 'Usuário não encontrado.',
}) {
  final user = firebaseAuth.currentUser;
  if (user != null) {
    return user;
  }
  throw FirebaseAuthException(code: 'user-not-found', message: message);
}
