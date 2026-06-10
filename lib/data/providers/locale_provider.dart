import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    _loadLocale();
    return const Locale('uk');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      if (languageCode == 'uk' || languageCode == 'en') {
        state = Locale(languageCode);
      } else {
        // Fallback for deprecated locales
        state = const Locale('uk');
        await prefs.setString('languageCode', 'uk');
      }
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (languageCode == 'uk' || languageCode == 'en') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
      state = Locale(languageCode);
    }
  }
}
