import 'dart:io';

Future<bool> hasInternetConnection(Duration timeout) async {
  final result = await InternetAddress.lookup('google.com').timeout(timeout);
  return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
}
