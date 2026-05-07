import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/components/app_bottom_nav.dart';
import '../../../../core/router/app_routes.dart';
import '../utils/youtube_webview_loader.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class _YoutubeVideo {
  const _YoutubeVideo({
    required this.videoId,
    required this.title,
    required this.durationSeconds,
  });

  final String videoId;
  final String title;
  final int durationSeconds;

  String get embedUrl =>
      'https://www.youtube.com/embed/$videoId?autoplay=1&rel=0';

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}

// ─── Dados estáticos ─────────────────────────────────────────────────────────

/// URL do embed ao vivo — troque pelo ID do vídeo/canal desejado.
/// Exemplo: 'https://www.youtube.com/embed/LIVE_VIDEO_ID?autoplay=1&mute=1'
const _liveEmbedUrl = 'https://www.youtube.com/watch?v=tMYtrEBNVAU';

/// Lista de vídeos curtos (~10 s) de cidades brasileiras no YouTube.
/// Substitua os videoId pelos IDs reais que preferir.
const _videos = <_YoutubeVideo>[
  _YoutubeVideo(
    videoId: 'NndkIDHVDFE',
    title: 'Video curto',
    durationSeconds: 10,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  late final WebViewController _liveController;
  bool _liveEnabled = false;
  bool _liveLoaded = false;

  @override
  void initState() {
    super.initState();
    _liveController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted && _liveEnabled) setState(() => _liveLoaded = true);
          },
        ),
      );
  }

  Future<void> _turnLiveOn() async {
    setState(() {
      _liveEnabled = true;
      _liveLoaded = false;
    });
    await _liveController.loadYoutubeUrlInWebView(_liveEmbedUrl);
  }

  Future<void> _turnLiveOff() async {
    setState(() {
      _liveEnabled = false;
      _liveLoaded = false;
    });
    await _liveController.loadHtmlString(
      '<!DOCTYPE html><html><body style="margin:0;background:#000"></body></html>',
    );
  }

  void _openVideo(_YoutubeVideo video) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => _VideoPlayerSheet(video: video),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.brandGreen,
              size: 34,
            ),
            onPressed: () => context.go(AppRoutes.home),
          ),
          title: const Text('Imagens'),
        ),
        bottomNavigationBar: const AppBottomNav(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LiveSection(
                controller: _liveController,
                enabled: _liveEnabled,
                loaded: _liveLoaded,
                onTurnOn: _turnLiveOn,
                onTurnOff: _turnLiveOff,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Vídeos curtos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headerBlue,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: _videos.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) => _VideoCard(
                    video: _videos[i],
                    onTap: () => _openVideo(_videos[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Live Section ─────────────────────────────────────────────────────────────

class _LiveSection extends StatelessWidget {
  const _LiveSection({
    required this.controller,
    required this.enabled,
    required this.loaded,
    required this.onTurnOn,
    required this.onTurnOff,
  });

  final WebViewController controller;
  final bool enabled;
  final bool loaded;
  final Future<void> Function() onTurnOn;
  final Future<void> Function() onTurnOff;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (enabled) WebViewWidget(controller: controller),
          if (!enabled)
            ColoredBox(
              color: Colors.black,
              child: Center(
                child: FilledButton.icon(
                  onPressed: () {
                    onTurnOn();
                  },
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Ligar ao vivo'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          if (enabled && !loaded)
            const ColoredBox(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          if (enabled)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 7),
                    SizedBox(width: 5),
                    Text(
                      'AO VIVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (enabled)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: IconButton.filledTonal(
                onPressed: () {
                  onTurnOff();
                },
                icon: const Icon(Icons.power_settings_new),
                tooltip: 'Desligar ao vivo',
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Video Card ───────────────────────────────────────────────────────────────

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video, required this.onTap});

  final _YoutubeVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.neutral0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              // Thumbnail + badge de duração
              SizedBox(
                width: 110,
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: AppColors.neutral600),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${video.durationSeconds}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Título
              Expanded(
                child: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.headerBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: AppSpacing.md),
                child: Icon(
                  Icons.play_circle_outline,
                  color: AppColors.brandGreen,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Video Player Sheet ───────────────────────────────────────────────────────

class _VideoPlayerSheet extends StatefulWidget {
  const _VideoPlayerSheet({required this.video});

  final _YoutubeVideo video;

  @override
  State<_VideoPlayerSheet> createState() => _VideoPlayerSheetState();
}

class _VideoPlayerSheetState extends State<_VideoPlayerSheet> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadYoutubeUrlInWebView(widget.video.embedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
