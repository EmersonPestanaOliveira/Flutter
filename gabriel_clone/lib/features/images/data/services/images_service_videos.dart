part of 'images_service.dart';

Future<List<VideoInfo>> _loadRecordedVideos(
  FirebaseFirestore firestore,
  String userId,
  List<LinkedCameraInfo> cameras,
) async {
  final videos = <String, VideoInfo>{};
  final cameraIds = cameras
      .map((camera) => camera.id)
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList(growable: false);
  final cameraNames = {for (final camera in cameras) camera.id: camera.name};

  await _addUserVideos(firestore, videos, userId, cameraNames);
  await _addCameraVideos(firestore, videos, cameraIds, cameraNames);

  return videos.values.toList(growable: false)
    ..removeWhere((video) => video.url.isEmpty)
    ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
}

Future<List<VideoInfo>> _loadLiveVideos(FirebaseFirestore firestore) async {
  try {
    final snapshot = await firestore.collection('videos_ao_vivo').get();
    final videos =
        snapshot.docs
            .map(
              (doc) => VideoInfo.fromFirestore(doc.id, doc.data(), live: true),
            )
            .where((video) => video.url.isNotEmpty)
            .toList(growable: false)
          ..sort((a, b) => a.cameraName.compareTo(b.cameraName));

    return videos.isNotEmpty ? videos : ImagesService.defaultCetLiveVideos;
  } catch (_) {
    return ImagesService.defaultCetLiveVideos;
  }
}

List<VideoInfo> _liveVideosFromCameras(List<LinkedCameraInfo> cameras) {
  return cameras
      .where((camera) => camera.liveUrl.isNotEmpty)
      .map(
        (camera) => VideoInfo(
          id: 'live_${camera.id}',
          cameraId: camera.id,
          cameraName: camera.name,
          url: camera.liveUrl,
          recordedAt: ImagesService.zeroDate,
          durationSeconds: 0,
          isLive: true,
        ),
      )
      .toList(growable: false);
}

List<VideoInfo> _mergeLiveVideos(List<VideoInfo> videos) {
  final merged = <String, VideoInfo>{};
  for (final video in videos) {
    final key = video.cameraId.isNotEmpty ? video.cameraId : video.url;
    merged[key] = video;
  }
  return merged.values.toList(growable: false)
    ..sort((a, b) => a.cameraName.compareTo(b.cameraName));
}
