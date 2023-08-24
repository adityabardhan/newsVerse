import 'package:flutter/cupertino.dart';
import 'package:newsverse/provider/sharedPreferences.dart';

class AppStateNotifier with ChangeNotifier {
  DarkTheme darkThemePreference = DarkTheme();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}