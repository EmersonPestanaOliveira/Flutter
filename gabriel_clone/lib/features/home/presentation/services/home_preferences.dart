import 'package:shared_preferences/shared_preferences.dart';

class HomePreferences {
  static const _alertMapPreferenceKey = 'home_alert_map_enabled';

  Future<bool?> loadAlertMapEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_alertMapPreferenceKey);
  }

  Future<void> saveAlertMapEnabled(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_alertMapPreferenceKey, value);
  }
}
