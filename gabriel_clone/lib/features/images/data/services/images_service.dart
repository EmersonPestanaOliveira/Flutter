import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/images_data.dart';
import '../models/linked_camera_info.dart';
import '../models/video_info.dart';

part 'images_service_cameras.dart';
part 'images_service_videos.dart';
part 'images_service_video_queries.dart';

class ImagesService {
  ImagesService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static final zeroDate = DateTime.fromMillisecondsSinceEpoch(0);

  static final defaultCetLiveVideos = [
    VideoInfo(
      id: 'cet_cameras_geral',
      cameraId: 'cet_cameras_geral',
      cameraName: 'CET - Câmeras ao vivo',
      url: 'https://cameras.cetsp.com.br/View/Cam.aspx',
      recordedAt: zeroDate,
      durationSeconds: 0,
      isLive: true,
    ),
    VideoInfo(
      id: 'cet_cameras_zona_09',
      cameraId: 'cet_cameras_zona_09',
      cameraName: 'CET - Câmeras Zona 09',
      url: 'https://cameras.cetsp.com.br/View/Cam.aspx?s=09',
      recordedAt: zeroDate,
      durationSeconds: 0,
      isLive: true,
    ),
  ];

  Future<ImagesData> load() async {
    final user = _auth.currentUser;
    if (user == null) {
      return ImagesData(liveVideos: defaultCetLiveVideos);
    }

    final cameras = await _loadLinkedCameras(_firestore, user.uid);
    final recordedVideos = await _loadRecordedVideos(
      _firestore,
      user.uid,
      cameras,
    );
    final liveVideos = _mergeLiveVideos([
      ..._liveVideosFromCameras(cameras),
      ...await _loadLiveVideos(_firestore),
    ]);

    return ImagesData(
      recordedVideos: recordedVideos,
      liveVideos: liveVideos,
      cameras: cameras,
    );
  }

}
