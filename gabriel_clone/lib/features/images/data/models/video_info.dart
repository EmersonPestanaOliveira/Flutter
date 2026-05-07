import 'package:cloud_firestore/cloud_firestore.dart';

class VideoInfo {
  const VideoInfo({
    required this.id,
    required this.cameraId,
    required this.cameraName,
    required this.url,
    required this.recordedAt,
    required this.durationSeconds,
    required this.isLive,
  });

  final String id;
  final String cameraId;
  final String cameraName;
  final String url;
  final DateTime recordedAt;
  final int durationSeconds;
  final bool isLive;

  factory VideoInfo.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    bool live = false,
  }) {
    return VideoInfo(
      id: id,
      cameraId: data['cameraId'] as String? ?? '',
      cameraName:
          data['cameraNome'] as String? ??
          data['nome'] as String? ??
          data['titulo'] as String? ??
          'Câmera',
      url: _cleanUrl(
        data['url'] as String? ??
            data['linkAoVivo'] as String? ??
            data['link_ao_vivo'] as String? ??
            data['streamUrl'] as String? ??
            '',
      ),
      recordedAt:
          (data['gravadoEm'] as Timestamp?)?.toDate() ??
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      durationSeconds: (data['duracaoSegundos'] as num?)?.toInt() ?? 0,
      isLive: live,
    );
  }

  VideoInfo copyWith({String? cameraName}) {
    return VideoInfo(
      id: id,
      cameraId: cameraId,
      cameraName: cameraName ?? this.cameraName,
      url: url,
      recordedAt: recordedAt,
      durationSeconds: durationSeconds,
      isLive: isLive,
    );
  }

  static String _cleanUrl(String value) {
    var url = value.trim();
    while (url.length >= 2 &&
        ((url.startsWith('"') && url.endsWith('"')) ||
            (url.startsWith("'") && url.endsWith("'")))) {
      url = url.substring(1, url.length - 1).trim();
    }
    return url.replaceAll(r'\"', '"').replaceAll('&amp;', '&').trim();
  }
}
