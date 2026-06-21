import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService(this._prefs);

  static const String themeModeKey = 'themeMode';
  static const String onboardingCompletedKey = 'onboardingCompleted';
  static const String notificationEnabledKey = 'notificationEnabled';
  static const String userNameKey = 'userName';

  final SharedPreferences _prefs;

  static Future<SettingsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
  }

  ThemeMode get themeMode {
    final value = _prefs.getString(themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<bool> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString(themeModeKey, value);
  }

  bool get onboardingCompleted =>
      _prefs.getBool(onboardingCompletedKey) ?? false;

  Future<bool> setOnboardingCompleted(bool value) {
    return _prefs.setBool(onboardingCompletedKey, value);
  }

  bool get notificationEnabled =>
      _prefs.getBool(notificationEnabledKey) ?? true;

  Future<bool> setNotificationEnabled(bool value) {
    return _prefs.setBool(notificationEnabledKey, value);
  }

  String get userName => _prefs.getString(userNameKey) ?? '';

  Future<bool> setUserName(String value) {
    return _prefs.setString(userNameKey, value);
  }

  Future<bool> clearAll() async {
    await _prefs.remove(themeModeKey);
    await _prefs.remove(onboardingCompletedKey);
    await _prefs.remove(notificationEnabledKey);
    await _prefs.remove(userNameKey);
    return true;
  }
}
