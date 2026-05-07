import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../data/models/video_info.dart';
import 'video_card.dart';

class VideoList extends StatelessWidget {
  const VideoList({
    required this.videos,
    required this.emptyMessage,
    super.key,
  });

  final List<VideoInfo> videos;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.headerBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: videos.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => VideoCard(video: videos[index]),
    );
  }
}
