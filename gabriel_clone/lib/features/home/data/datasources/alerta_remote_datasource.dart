import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../models/alerta_model.dart';

abstract interface class AlertaRemoteDatasource {
  Future<List<AlertaModel>> getAlertas();
}

class AlertaRemoteDatasourceImpl implements AlertaRemoteDatasource {
  const AlertaRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<List<AlertaModel>> getAlertas() async {
    try {
      final snapshot = await firestore
          .collection('alertas')
          .orderBy('data', descending: true)
          .get();

      return snapshot.docs.map(AlertaModel.fromFirestore).toList();
    } on FirebaseException catch (exception) {
      throw FirebaseErrorHandler.handle(exception);
    }
  }
}