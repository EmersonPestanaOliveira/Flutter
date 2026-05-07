import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/images/presentation/utils/youtube_webview_loader.dart';

void main() {
  group('youtubeEmbedUrl', () {
    test('converte link watch em embed com origin', () {
      final url = youtubeEmbedUrl('https://www.youtube.com/watch?v=tMYtrEBNVAU');

      expect(url, isNotNull);
      final uri = Uri.parse(url!);
      expect(uri.host, 'www.youtube.com');
      expect(uri.path, '/embed/tMYtrEBNVAU');
      expect(uri.queryParameters['autoplay'], '1');
      expect(uri.queryParameters['playsinline'], '1');
      expect(uri.queryParameters['rel'], '0');
      expect(uri.queryParameters['origin'], 'https://gabriel-d3995.web.app');
    });

    test('converte youtu.be em embed', () {
      final url = youtubeEmbedUrl('https://youtu.be/NndkIDHVDFE');

      expect(Uri.parse(url!).path, '/embed/NndkIDHVDFE');
    });

    test('aceita somente o id do video', () {
      final url = youtubeEmbedUrl('NndkIDHVDFE');

      expect(Uri.parse(url!).path, '/embed/NndkIDHVDFE');
    });

    test('preserva query parameters existentes do embed', () {
      final url = youtubeEmbedUrl(
        'https://www.youtube.com/embed/NndkIDHVDFE?mute=1',
      );

      final uri = Uri.parse(url!);
      expect(uri.path, '/embed/NndkIDHVDFE');
      expect(uri.queryParameters['mute'], '1');
      expect(uri.queryParameters['autoplay'], '1');
    });

    test('retorna null para urls que nao sao do YouTube', () {
      expect(youtubeEmbedUrl('https://example.com/video'), isNull);
    });
  });
}
