import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/network/backend_error_mapper.dart';
import '../models/camera_model.dart';

abstract interface class CameraRemoteDatasource {
  Future<List<CameraModel>> getCameras();
}

class CameraRemoteDatasourceImpl implements CameraRemoteDatasource {
  const CameraRemoteDatasourceImpl(this.firestore);

  static const _saoPauloInitialLimit = 540;
  static const _rioInitialLimit = 360;

  final FirebaseFirestore firestore;

  @override
  Future<List<CameraModel>> getCameras() async {
    try {
      final collection = firestore.collection('cameras');
      final snapshots = await Future.wait([
        collection
            .where('regiao', whereIn: ['Grande São Paulo', 'Grande SÃ£o Paulo'])
            .limit(_saoPauloInitialLimit)
            .get(),
        collection
            .where('regiao', isEqualTo: 'Grande Rio')
            .limit(_rioInitialLimit)
            .get(),
      ]);

      return snapshots
          .expand((snapshot) => snapshot.docs)
          .map(CameraModel.fromFirestore)
          .where((camera) => camera.ativo)
          .toList(growable: false);
    } catch (error) {
      throw BackendErrorMapper.toFailure(error);
    }
  }
}
