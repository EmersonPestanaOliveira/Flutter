import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../profile/profile_photo_cache.dart';
import 'auth_content_type.dart';
import 'auth_user_requirements.dart';

class AuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    ProfilePhotoCache? profilePhotoCache,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _storage = storage,
       _profilePhotoCache = profilePhotoCache,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ProfilePhotoCache? _profilePhotoCache;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _firebaseAuth.currentUser;

  String? get cachedProfilePhotoUrl {
    final user = currentUser;
    if (user == null) {
      return null;
    }
    return _profilePhotoCache?.read(user.uid) ?? user.photoURL;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> registerWithEmail({
    required String name,
    required String birthDate,
    required String cpf,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      return;
    }

    await user.updateDisplayName(name.trim());
    await _firestore.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'birthDate': birthDate.trim(),
      'cpf': cpf.trim(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'provider': 'password',
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> loadUserProfile() async {
    final user = requireCurrentUser(_firebaseAuth);
    final document = await _firestore.collection('users').doc(user.uid).get();
    final data = document.data() ?? <String, dynamic>{};
    await _cacheProfilePhoto(
      user.uid,
      data['photoUrl'] as String? ?? user.photoURL,
    );
    return data;
  }

  Future<void> updateUserProfile({
    required String name,
    required String birthDate,
    required String gender,
    required String phone,
    required String cpf,
  }) async {
    final user = requireCurrentUser(_firebaseAuth);
    await user.updateDisplayName(name.trim());
    await _firestore.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'birthDate': birthDate.trim(),
      'gender': gender,
      'phone': phone.trim(),
      'cpf': cpf.trim(),
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> updateUserProfilePhoto({
    required Uint8List bytes,
    required String contentType,
  }) async {
    var user = requireCurrentUser(
      _firebaseAuth,
      message: 'Usuário não encontrado.',
    );
    await user.reload();
    user = requireCurrentUser(_firebaseAuth, message: 'Usuário não encontrado.');
    await user.getIdToken(true);

    final photoUrl = await _uploadProfilePhoto(user, bytes, contentType);
    await user.updatePhotoURL(photoUrl);
    await _firestore.collection('users').doc(user.uid).set({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _cacheProfilePhoto(user.uid, photoUrl);

    return photoUrl;
  }

  Future<void> deleteAccount() async {
    final user = requireCurrentUser(_firebaseAuth);
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      return;
    }

    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
      'provider': 'google',
    }, SetOptions(merge: true));
    await _cacheProfilePhoto(user.uid, user.photoURL);
  }

  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<String> _uploadProfilePhoto(
    User user,
    Uint8List bytes,
    String contentType,
  ) async {
    final extension = extensionFromContentType(contentType);
    final reference = _storage
        .ref()
        .child('users')
        .child(user.uid)
        .child('profile')
        .child('photo.$extension');

    await reference.putData(bytes, SettableMetadata(contentType: contentType));
    return reference.getDownloadURL();
  }

  Future<void> _cacheProfilePhoto(String userId, String? photoUrl) async {
    await _profilePhotoCache?.save(userId, photoUrl);
  }
}
