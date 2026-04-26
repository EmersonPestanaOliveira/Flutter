import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia da biometria por uid.
/// Tres estados: enabled, disabled, undecided (wasAsked=false).
class BiometricPreferences {
  BiometricPreferences._();
  static final instance = BiometricPreferences._();

  static const _enabledPrefix = 'biometric_enabled_';
  static const _askedPrefix = 'biometric_asked_';

  Future<bool> isEnabled(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool('$_enabledPrefix$uid') ?? false;
    debugPrint('[BiometricPrefs] isEnabled($uid) = $v');
    return v;
  }

  Future<void> setEnabled(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setBool('$_enabledPrefix$uid', value);
    debugPrint('[BiometricPrefs] setEnabled($uid, $value) -> ok=$ok');
  }

  Future<bool> wasAsked(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool('$_askedPrefix$uid') ?? false;
    debugPrint('[BiometricPrefs] wasAsked($uid) = $v');
    return v;
  }

  Future<void> markAsAsked(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setBool('$_askedPrefix$uid', true);
    debugPrint('[BiometricPrefs] markAsAsked($uid) -> ok=$ok');
  }

  Future<void> clear(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_enabledPrefix$uid');
    await prefs.remove('$_askedPrefix$uid');
    debugPrint('[BiometricPrefs] clear($uid)');
  }
}
