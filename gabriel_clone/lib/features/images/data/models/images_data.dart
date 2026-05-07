import 'linked_camera_info.dart';
import 'video_info.dart';

class ImagesData {
  const ImagesData({
    this.recordedVideos = const [],
    this.liveVideos = const [],
    this.cameras = const [],
  });

  final List<VideoInfo> recordedVideos;
  final List<VideoInfo> liveVideos;
  final List<LinkedCameraInfo> cameras;
}
