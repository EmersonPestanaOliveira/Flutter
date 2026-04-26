import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConnectionValidator {
  FirebaseConnectionValidator({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _testDocument =>
      _firestore.collection('_diagnostics').doc('firestore_connection_test');

  Future<void> createAndReadTestDocument() async {
    await _testDocument.set({
      'description': 'Gabriel Clone Firestore connection test',
      'createdAt': FieldValue.serverTimestamp(),
      'source': 'app',
    });

    final snapshot = await _testDocument.get();
    if (!snapshot.exists) {
      throw Exception('Documento de teste nao foi encontrado apos a gravacao.');
    }
  }

  Future<void> deleteTestDocument() async {
    await _testDocument.delete();
  }
}