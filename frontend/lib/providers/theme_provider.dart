import 'package:flutter/material.dart';
import 'package:frontend/theme/dark_mode.dart';
import 'package:frontend/theme/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      _themeData = lightMode;
    } else {
      _themeData = darkMode;
    }
    notifyListeners();
  }
}
