import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'theme_mode';
const _onboardingCompletedKey = 'onboarding_completed';
const _userNameKey = 'user_name';
const _notificationEnabledKey = 'notification_enabled';
const _notificationLeadMinutesKey = 'notification_lead_minutes';
const _onboardingPersonaKey = 'onboarding_persona';

// Legacy SettingsService keys (migrated on load)
const _legacyThemeModeKey = 'themeMode';
const _legacyOnboardingKey = 'onboardingCompleted';
const _legacyUserNameKey = 'userName';
const _legacyNotificationKey = 'notificationEnabled';

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.onboardingCompleted,
    required this.userName,
    required this.notificationEnabled,
    this.notificationLeadMinutes = 5,
    this.onboardingPersona = '',
  });

  final ThemeMode themeMode;
  final bool onboardingCompleted;
  final String userName;
  final bool notificationEnabled;
  final int notificationLeadMinutes;
  final String onboardingPersona;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? onboardingCompleted,
    String? userName,
    bool? notificationEnabled,
    int? notificationLeadMinutes,
    String? onboardingPersona,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      userName: userName ?? this.userName,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notificationLeadMinutes:
          notificationLeadMinutes ?? this.notificationLeadMinutes,
      onboardingPersona: onboardingPersona ?? this.onboardingPersona,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  SharedPreferences? _prefs;

  @override
  AppSettings build() {
    return const AppSettings(
      themeMode: ThemeMode.system,
      onboardingCompleted: false,
      userName: '',
      notificationEnabled: true,
      notificationLeadMinutes: 5,
      onboardingPersona: '',
    );
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    final themeMode = _loadThemeMode(_prefs!);
    final onboardingCompleted = _loadOnboardingCompleted(_prefs!);
    final userName = _loadUserName(_prefs!);
    final notificationEnabled = _loadNotificationEnabled(_prefs!);
    final notificationLeadMinutes = _loadNotificationLeadMinutes(_prefs!);
    final onboardingPersona = _prefs!.getString(_onboardingPersonaKey) ?? '';

    state = AppSettings(
      themeMode: themeMode,
      onboardingCompleted: onboardingCompleted,
      userName: userName,
      notificationEnabled: notificationEnabled,
      notificationLeadMinutes: notificationLeadMinutes,
      onboardingPersona: onboardingPersona,
    );
  }

  ThemeMode _loadThemeMode(SharedPreferences prefs) {
    if (prefs.containsKey(_themeModeKey)) {
      final index = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
      return ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
    }

    final legacy = prefs.getString(_legacyThemeModeKey);
    final mode = switch (legacy) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    prefs.setInt(_themeModeKey, mode.index);
    return mode;
  }

  bool _loadOnboardingCompleted(SharedPreferences prefs) {
    if (prefs.containsKey(_onboardingCompletedKey)) {
      return prefs.getBool(_onboardingCompletedKey) ?? false;
    }

    final legacy = prefs.getBool(_legacyOnboardingKey) ?? false;
    prefs.setBool(_onboardingCompletedKey, legacy);
    return legacy;
  }

  String _loadUserName(SharedPreferences prefs) {
    if (prefs.containsKey(_userNameKey)) {
      return prefs.getString(_userNameKey) ?? '';
    }

    final legacy = prefs.getString(_legacyUserNameKey) ?? '';
    prefs.setString(_userNameKey, legacy);
    return legacy;
  }

  bool _loadNotificationEnabled(SharedPreferences prefs) {
    if (prefs.containsKey(_notificationEnabledKey)) {
      return prefs.getBool(_notificationEnabledKey) ?? true;
    }

    final legacy = prefs.getBool(_legacyNotificationKey) ?? true;
    prefs.setBool(_notificationEnabledKey, legacy);
    return legacy;
  }

  int _loadNotificationLeadMinutes(SharedPreferences prefs) {
    return prefs.getInt(_notificationLeadMinutesKey) ?? 5;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(_themeModeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> completeOnboarding() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_onboardingCompletedKey, true);
    state = state.copyWith(onboardingCompleted: true);
  }

  Future<void> setUserName(String name) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_userNameKey, name);
    state = state.copyWith(userName: name);
  }

  Future<void> setOnboardingPersona(String persona) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_onboardingPersonaKey, persona);
    state = state.copyWith(onboardingPersona: persona);
  }

  Future<void> completeOnboardingWith({
    required String userName,
    required String persona,
    bool notificationsEnabled = true,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_userNameKey, userName);
    await _prefs!.setString(_onboardingPersonaKey, persona);
    await _prefs!.setBool(_onboardingCompletedKey, true);
    await _prefs!.setBool(_notificationEnabledKey, notificationsEnabled);
    state = state.copyWith(
      userName: userName,
      onboardingPersona: persona,
      onboardingCompleted: true,
      notificationEnabled: notificationsEnabled,
    );
  }

  Future<bool> setNotificationEnabled(bool enabled) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_notificationEnabledKey, enabled);
    state = state.copyWith(notificationEnabled: enabled);
    return enabled;
  }

  Future<void> setNotificationLeadMinutes(int minutes) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(_notificationLeadMinutesKey, minutes);
    state = state.copyWith(notificationLeadMinutes: minutes);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
