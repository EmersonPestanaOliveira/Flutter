part of 'images_service.dart';

Future<void> _addUserVideos(
  FirebaseFirestore firestore,
  Map<String, VideoInfo> videos,
  String userId,
  Map<String, String> cameraNames,
) async {
  await _tryAddVideos(
    videos,
    cameraNames,
    firestore.collection('videos').where('users', arrayContains: userId),
  );
  await _tryAddVideos(
    videos,
    cameraNames,
    firestore.collection('videos').where('userId', isEqualTo: userId),
  );
}

Future<void> _addCameraVideos(
  FirebaseFirestore firestore,
  Map<String, VideoInfo> videos,
  List<String> cameraIds,
  Map<String, String> cameraNames,
) async {
  for (var index = 0; index < cameraIds.length; index += 10) {
    final chunk = cameraIds.skip(index).take(10).toList(growable: false);
    if (chunk.isEmpty) {
      continue;
    }
    await _tryAddVideos(
      videos,
      cameraNames,
      firestore.collection('videos').where('cameraId', whereIn: chunk),
    );
  }
}

Future<void> _tryAddVideos(
  Map<String, VideoInfo> videos,
  Map<String, String> cameraNames,
  Query<Map<String, dynamic>> query,
) async {
  try {
    final snapshot = await query.get();
    for (final doc in snapshot.docs) {
      final video = VideoInfo.fromFirestore(doc.id, doc.data());
      videos[video.id] = video.copyWith(
        cameraName: video.cameraName.isNotEmpty
            ? video.cameraName
            : cameraNames[video.cameraId],
      );
    }
  } catch (_) {}
}
