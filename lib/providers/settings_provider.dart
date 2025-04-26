import 'package:flutter/material.dart';


class SettingsProvider with ChangeNotifier {
  
  bool _isAccessibilityModeEnabled = false;
  bool get isAccessibilityModeEnabled => _isAccessibilityModeEnabled;
  
  ThemeMode _themeMode = ThemeMode.system; 
  ThemeMode get themeMode => _themeMode;
  bool get isDarkModeEnabled => _themeMode == ThemeMode.dark;

  SettingsProvider() {

  }

  void toggleAccessibilityMode(bool value) async {
     _isAccessibilityModeEnabled = value;
    
    print("Accessibility Mode toggled in Provider: $_isAccessibilityModeEnabled");
    notifyListeners();
  }

  void toggleDarkMode(bool enableDarkMode) async {
    _themeMode = enableDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    print("ThemeMode changed in Provider: $_themeMode");
    notifyListeners();
  }
} 