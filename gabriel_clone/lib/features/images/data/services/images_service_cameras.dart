part of 'images_service.dart';

Future<List<LinkedCameraInfo>> _loadLinkedCameras(
  FirebaseFirestore firestore,
  String userId,
) async {
  final camerasById = <String, LinkedCameraInfo>{};

  await _addCamerasFromUsersArray(firestore, camerasById, userId);
  await _addCamerasFromPlaceLinks(firestore, camerasById, userId);
  await _addCameraFromUserProfile(firestore, camerasById, userId);

  return camerasById.values.toList(growable: false);
}

Future<void> _addCamerasFromUsersArray(
  FirebaseFirestore firestore,
  Map<String, LinkedCameraInfo> camerasById,
  String userId,
) async {
  final snapshot = await firestore
      .collection('cameras')
      .where('users', arrayContains: userId)
      .get();

  for (final doc in snapshot.docs) {
    camerasById[doc.id] = LinkedCameraInfo.fromFirestore(doc.id, doc.data());
  }
}

Future<void> _addCamerasFromPlaceLinks(
  FirebaseFirestore firestore,
  Map<String, LinkedCameraInfo> camerasById,
  String userId,
) async {
  final links = await firestore
      .collection('users')
      .doc(userId)
      .collection('localidades')
      .where('status', isEqualTo: 'ativo')
      .get();

  for (final doc in links.docs) {
    final camera = doc.data()['camera'];
    if (camera is! Map) {
      continue;
    }
    final info = LinkedCameraInfo.fromMap(Map<String, dynamic>.from(camera));
    camerasById[info.id] = info;
  }
}

Future<void> _addCameraFromUserProfile(
  FirebaseFirestore firestore,
  Map<String, LinkedCameraInfo> camerasById,
  String userId,
) async {
  final userDocument = await firestore.collection('users').doc(userId).get();
  final camera = userDocument.data()?['cameraAtrelada'];
  if (camera is! Map) {
    return;
  }

  final info = LinkedCameraInfo.fromMap(Map<String, dynamic>.from(camera));
  camerasById[info.id] = info;
}
