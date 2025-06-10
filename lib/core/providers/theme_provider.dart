import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;

  ThemeModeNotifier(this.ref) : super(_getInitialThemeMode());

  static ThemeMode _getInitialThemeMode() {
    final preferencesService = PreferencesService();
    return preferencesService.getDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleThemeMode() {
    final preferencesService = PreferencesService();
    final isDarkMode = state == ThemeMode.dark;

    state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    preferencesService.setDarkMode(!isDarkMode);
  }
}
