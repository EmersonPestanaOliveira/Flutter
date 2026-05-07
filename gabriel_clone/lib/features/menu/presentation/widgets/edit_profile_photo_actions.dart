part of '../menu_pages.dart';

extension _EditProfilePhotoActions on _EditProfilePageState {
  Future<void> _showPhotoSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Tirar foto'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Escolher da galeria'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    await _pickAndUploadProfilePhoto(source);
  }

  Future<void> _pickAndUploadProfilePhoto(ImageSource source) async {
    setState(() => _isUploadingPhoto = true);
    try {
      final hasPermission = await _requestPhotoPermission(source);
      if (!hasPermission) {
        return;
      }

      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        return;
      }

      final photoUrl = await _authService.updateUserProfilePhoto(
        bytes: await pickedFile.readAsBytes(),
        contentType: pickedFile.mimeType ?? 'image/jpeg',
      );

      if (!mounted) {
        return;
      }

      setState(() => _photoUrl = photoUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppErrorNotifier.showMessage(context, _profilePhotoErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<bool> _requestPhotoPermission(ImageSource source) async {
    final status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await _requestGalleryPermission();

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (!mounted) {
      return false;
    }

    final label = source == ImageSource.camera ? 'camera' : 'galeria';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permita acesso a $label para atualizar sua foto.'),
        action: status.isPermanentlyDenied
            ? SnackBarAction(label: 'Abrir ajustes', onPressed: openAppSettings)
            : null,
      ),
    );

    return false;
  }

  Future<PermissionStatus> _requestGalleryPermission() async {
    final photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted ||
        photosStatus.isLimited ||
        photosStatus.isPermanentlyDenied) {
      return photosStatus;
    }

    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted ||
        storageStatus.isLimited ||
        storageStatus.isPermanentlyDenied) {
      return storageStatus;
    }

    return photosStatus;
  }
}
