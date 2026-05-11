import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng?> searchAddressCoordinates(String query) async {
  final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
    'q': query,
    'format': 'json',
    'limit': '1',
  });
  final client = HttpClient();
  final request = await client.getUrl(uri);
  request.headers.set('User-Agent', 'gabriel-clone-ocorrencias');
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();

  final results = jsonDecode(body) as List<dynamic>;
  if (results.isEmpty) {
    return null;
  }

  final first = results.first as Map<String, dynamic>;
  return LatLng(
    double.parse(first['lat'] as String),
    double.parse(first['lon'] as String),
  );
}
