import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeStyle {

  static ThemeData _darkTheme =  ThemeData(
    hintColor: Colors.red,
    brightness: Brightness.dark,
    primaryColor: Colors.amber,

  );

  static final ThemeData _lightTheme = ThemeData(
      hintColor: Colors.pink,
      brightness: Brightness.light,
      primaryColor: Colors.blue
  );

}