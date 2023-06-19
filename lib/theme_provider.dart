import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _currentThemeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void setThemeMode(ThemeMode themeMode) {
    _currentThemeMode = themeMode;
    notifyListeners();
  }
}
