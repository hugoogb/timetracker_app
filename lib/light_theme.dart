import 'package:flutter/material.dart';

class LightTheme {
  LightTheme._();

  static const _primaryColor = Colors.blue;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
    ),
    iconTheme: const IconThemeData(
      color: _primaryColor,
    ),
  );
}
