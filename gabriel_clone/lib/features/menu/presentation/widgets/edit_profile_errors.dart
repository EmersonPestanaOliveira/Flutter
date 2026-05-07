part of '../menu_pages.dart';

String _profilePhotoErrorMessage(Object error) {
  if (error is MissingPluginException) {
    return 'Reinstale o app para carregar camera e galeria.';
  }

  if (error is PlatformException) {
    return switch (error.code) {
      'camera_access_denied' => 'Permita acesso a camera para tirar a foto.',
      'photo_access_denied' => 'Permita acesso a galeria para escolher a foto.',
      'channel-error' =>
        'Reinstale o app para carregar o seletor de fotos nativo.',
      _ => error.message ?? 'Nao foi possivel selecionar a foto.',
    };
  }

  if (error is FirebaseException) {
    return BackendErrorMapper.message(error);
  }

  return BackendErrorMapper.message(error);
}
