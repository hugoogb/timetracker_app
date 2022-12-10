import 'package:flutter/material.dart';

class LightTheme {
  LightTheme._();

  static const Color _iconColor = Colors.yellow;
  static const Color _lightPrimaryColor = Colors.pinkAccent;
  static const Color _lightPrimaryVariantColor = Colors.blue;
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightPrimaryVariantColor,
    appBarTheme: const AppBarTheme(
        color: _lightPrimaryVariantColor,
        iconTheme: IconThemeData(
          color: _lightOnPrimaryColor,
        )),
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: _iconColor,
    ),
    textTheme: _lightTextTheme,
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: _lightScreenHeadingTextStyle,
    bodyText1: _lightScreenTaskNameStyle,
    bodyText2: _lightScreenTaskDurationStyle,
  );

  static const TextStyle _lightScreenHeadingTextStyle = TextStyle(
    fontSize: 48.0,
    color: _lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenTaskNameStyle = TextStyle(
    fontSize: 20.0,
    color: _lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenTaskDurationStyle = TextStyle(
    fontSize: 16.0,
    color: _lightOnPrimaryColor,
  );
}
