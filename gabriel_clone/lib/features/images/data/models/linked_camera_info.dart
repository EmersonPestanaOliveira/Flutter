class LinkedCameraInfo {
  const LinkedCameraInfo({
    required this.id,
    required this.name,
    required this.liveUrl,
  });

  final String id;
  final String name;
  final String liveUrl;

  factory LinkedCameraInfo.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return LinkedCameraInfo(
      id: id,
      name: data['nome'] as String? ?? data['cameraNome'] as String? ?? id,
      liveUrl: _readLiveUrl(data),
    );
  }

  factory LinkedCameraInfo.fromMap(Map<String, dynamic> data) {
    final id =
        data['id'] as String? ??
        data['cameraId'] as String? ??
        data['documentId'] as String? ??
        '';

    return LinkedCameraInfo(
      id: id,
      name: data['nome'] as String? ?? data['cameraNome'] as String? ?? id,
      liveUrl: _readLiveUrl(data),
    );
  }

  static String _readLiveUrl(Map<String, dynamic> data) {
    return data['linkAoVivo'] as String? ??
        data['link_ao_vivo'] as String? ??
        data['streamUrl'] as String? ??
        '';
  }
}
