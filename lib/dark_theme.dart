import 'package:flutter/material.dart';

class DarkTheme {
  DarkTheme._();

  static const _primaryColor = Colors.orange;

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
    ),
    iconTheme: const IconThemeData(
      color: _primaryColor,
    ),
  );
}
