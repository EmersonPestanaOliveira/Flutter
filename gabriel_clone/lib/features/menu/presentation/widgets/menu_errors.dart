part of '../menu_pages.dart';

String _placeFlowErrorMessage(Object error) {
  if (error is FirebaseException) {
    return BackendErrorMapper.message(error);
  }

  if (error is PlatformException) {
    return BackendErrorMapper.message(error);
  }

  return BackendErrorMapper.message(error);
}
