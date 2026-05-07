import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../data/models/video_info.dart';
import 'video_player_sheet.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({required this.video, super.key});

  final VideoInfo video;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.neutral0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        leading: CircleAvatar(
          backgroundColor: video.isLive
              ? AppColors.accentRed
              : AppColors.brandGreen,
          child: Icon(
            video.isLive ? Icons.live_tv : Icons.play_arrow,
            color: AppColors.neutral0,
          ),
        ),
        title: Text(
          video.cameraName,
          style: const TextStyle(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          video.isLive ? 'Ao vivo' : _videoSubtitle(video),
          style: const TextStyle(color: AppColors.neutral600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openVideo(context),
      ),
    );
  }

  String _videoSubtitle(VideoInfo video) {
    final date = video.recordedAt.millisecondsSinceEpoch == 0
        ? ''
        : '${video.recordedAt.day.toString().padLeft(2, '0')}/'
              '${video.recordedAt.month.toString().padLeft(2, '0')}/'
              '${video.recordedAt.year}';
    if (video.durationSeconds <= 0) {
      return date;
    }
    return '$date - ${video.durationSeconds}s';
  }

  void _openVideo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutral0,
      builder: (context) => VideoPlayerSheet(video: video),
    );
  }
}
