part of '../menu_pages.dart';

class _EditProfileHeader extends StatelessWidget {
  const _EditProfileHeader({required this.isBusy});

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: isBusy ? null : () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF00C982),
            size: 34,
          ),
        ),
        Expanded(
          child: Text(
            'Editar Perfil',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.headerBlue,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 50),
      ],
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.photoUrl,
    required this.isBusy,
    required this.onTap,
  });

  final String? photoUrl;
  final bool isBusy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 62,
            backgroundColor: AppColors.neutral300,
            backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
            child: isBusy
                ? const CircularProgressIndicator(color: AppColors.neutral0)
                : hasPhoto
                ? null
                : const Icon(Icons.person, size: 84, color: AppColors.neutral0),
          ),
          Positioned(
            right: 4,
            bottom: -1,
            child: Material(
              color: const Color(0xFF00C982),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const SizedBox.square(
                  dimension: 44,
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.neutral0,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

