import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

const _youtubeEmbedOrigin = 'https://gabriel-d3995.web.app';

extension YoutubeWebViewLoader on WebViewController {
  Future<void> loadYoutubeUrlInWebView(String url) async {
    final embedUrl = youtubeEmbedUrl(url);
    if (embedUrl == null) {
      return loadRequest(Uri.parse(url));
    }

    return loadHtmlString(
      _youtubeEmbedHtml(embedUrl),
      baseUrl: _youtubeEmbedOrigin,
    );
  }
}

String? youtubeEmbedUrl(String value) {
  final trimmed = value.trim();
  if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trimmed)) {
    return Uri.https('www.youtube.com', '/embed/$trimmed', {
      'autoplay': '1',
      'playsinline': '1',
      'rel': '0',
      'origin': _youtubeEmbedOrigin,
    }).toString();
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return null;
  }

  final host = uri.host.toLowerCase();
  final isYoutube =
      host == 'youtu.be' ||
      host == 'youtube.com' ||
      host == 'www.youtube.com' ||
      host == 'm.youtube.com' ||
      host == 'youtube-nocookie.com' ||
      host == 'www.youtube-nocookie.com';
  if (!isYoutube) {
    return null;
  }

  final videoId = _extractYoutubeVideoId(uri);
  final path = videoId != null ? '/embed/$videoId' : uri.path;
  final query = Map<String, String>.from(uri.queryParameters)
    ..remove('v')
    ..putIfAbsent('autoplay', () => '1')
    ..putIfAbsent('playsinline', () => '1')
    ..putIfAbsent('rel', () => '0')
    ..putIfAbsent('origin', () => _youtubeEmbedOrigin);

  return Uri.https('www.youtube.com', path, query).toString();
}

String? _extractYoutubeVideoId(Uri uri) {
  if (uri.host.toLowerCase() == 'youtu.be' && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }

  final watchId = uri.queryParameters['v'];
  if (watchId != null && watchId.isNotEmpty) {
    return watchId;
  }

  final segments = uri.pathSegments;
  if (segments.length >= 2 &&
      (segments.first == 'embed' || segments.first == 'shorts')) {
    return segments[1];
  }

  return null;
}

String _youtubeEmbedHtml(String embedUrl) {
  final escapedUrl = const HtmlEscape().convert(embedUrl);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="referrer" content="strict-origin-when-cross-origin">
  <style>
    html, body {
      margin: 0;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    iframe {
      position: absolute;
      inset: 0;
      width: 100%;
      height: 100%;
      border: 0;
    }
  </style>
</head>
<body>
  <iframe
    src="$escapedUrl"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen
    referrerpolicy="strict-origin-when-cross-origin">
  </iframe>
</body>
</html>
''';
}
