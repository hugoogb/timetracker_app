import 'package:flutter/material.dart';
import 'package:timetracker_app/colors.dart';
import 'package:timetracker_app/dark_theme.dart';
import 'package:timetracker_app/light_theme.dart';
import 'package:timetracker_app/page_activities.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TimeTracker',
        theme: _kShrineTheme,
        home: const PageActivities(0));
  }
}

// TODO: Build a Shrine Theme (103)
final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink100,
      onPrimary: kShrineBrown900,
      secondary: kShrineBrown900,
      error: kShrineErrorRed,
    ),
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}
