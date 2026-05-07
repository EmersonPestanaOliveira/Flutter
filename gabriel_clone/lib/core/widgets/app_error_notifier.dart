import 'package:flutter/material.dart';

import '../network/backend_error_mapper.dart';

abstract final class AppErrorNotifier {
  static void show(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(BackendErrorMapper.message(error))),
    );
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
