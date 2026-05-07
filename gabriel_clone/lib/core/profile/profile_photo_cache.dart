import 'package:shared_preferences/shared_preferences.dart';

class ProfilePhotoCache {
  const ProfilePhotoCache(this._preferences);

  static const _prefix = 'profile_photo_url';

  final SharedPreferences _preferences;

  String? read(String userId) {
    final value = _preferences.getString(_key(userId));
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }

  Future<void> save(String userId, String? photoUrl) async {
    final value = photoUrl?.trim();
    if (value == null || value.isEmpty) {
      await _preferences.remove(_key(userId));
      return;
    }
    await _preferences.setString(_key(userId), value);
  }

  Future<void> clear(String userId) => _preferences.remove(_key(userId));

  static String _key(String userId) => '$_prefix.$userId';
}
