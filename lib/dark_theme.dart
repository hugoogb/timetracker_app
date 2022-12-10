import 'package:flutter/material.dart';

class DarkTheme {
  DarkTheme._();

  static const Color _iconColor = Colors.orange;
  // static const Color _darkPrimaryColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // scaffoldBackgroundColor: _darkPrimaryColor,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
      color: _iconColor,
    )),
    colorScheme: const ColorScheme.dark(
      primary: _iconColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: _iconColor,
    ),
    textTheme: _darkTextTheme,
  );

  static const TextTheme _darkTextTheme = TextTheme(
    headline1: _darkScreenHeadingTextStyle,
    bodyText1: _darkScreenTaskNameStyle,
    bodyText2: _darkScreenTaskDurationStyle,
  );

  static const TextStyle _darkScreenHeadingTextStyle = TextStyle(
    fontSize: 48.0,
    color: _darkOnPrimaryColor,
  );

  static const TextStyle _darkScreenTaskNameStyle = TextStyle(
    fontSize: 20.0,
    color: _darkOnPrimaryColor,
  );

  static const TextStyle _darkScreenTaskDurationStyle = TextStyle(
    fontSize: 16.0,
    color: _darkOnPrimaryColor,
  );
}
