import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/app_settings_model.dart';

part 'app_settings_provider.g.dart';

@riverpod
class AppSettings extends _$AppSettings {
  static const _settingsKey = 'app_settings';

  @override
  AppSettingsModel build() {
    _loadSettings();
    return const AppSettingsModel(); // Returns default synchronously first
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        state = AppSettingsModel.fromJson(jsonDecode(settingsJson));
      } catch (e) {
        // If parsing fails, stick to defaults
      }
    }
  }

  Future<void> _saveSettings(AppSettingsModel newSettings) async {
    state = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(newSettings.toJson()));
  }

  void updateLanguage(String code) =>
      _saveSettings(state.copyWith(languageCode: code));

  void toggleTheme(bool isDark) =>
      _saveSettings(state.copyWith(isDarkMode: isDark));

  void toggleRideUpdates(bool val) =>
      _saveSettings(state.copyWith(notifyRideUpdates: val));

  void toggleNewMessages(bool val) =>
      _saveSettings(state.copyWith(notifyNewMessages: val));

  void togglePromotions(bool val) =>
      _saveSettings(state.copyWith(notifyPromotions: val));

  void toggleProfileVisibility(bool val) =>
      _saveSettings(state.copyWith(profilePublic: val));

  void toggleTwoFactor(bool val) =>
      _saveSettings(state.copyWith(twoFactorEnabled: val));
}
