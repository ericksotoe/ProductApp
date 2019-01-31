import 'package:flutter/material.dart';

final Color mainAccentColor = Color.fromRGBO(8, 37, 103, 0.9);

final ThemeData androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  accentColor: mainAccentColor,
  buttonColor: mainAccentColor,
);

final ThemeData iosTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  accentColor: mainAccentColor,
  buttonColor: mainAccentColor,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android ? androidTheme : iosTheme;
}