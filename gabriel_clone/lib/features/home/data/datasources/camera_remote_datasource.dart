import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../models/camera_model.dart';

abstract interface class CameraRemoteDatasource {
  Future<List<CameraModel>> getCameras();
}

class CameraRemoteDatasourceImpl implements CameraRemoteDatasource {
  const CameraRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<List<CameraModel>> getCameras() async {
    try {
      final snapshot = await firestore
          .collection('cameras')
          .where('ativo', isEqualTo: true)
          .get();

      return snapshot.docs.map(CameraModel.fromFirestore).toList();
    } on FirebaseException catch (exception) {
      throw FirebaseErrorHandler.handle(exception);
    }
  }
}