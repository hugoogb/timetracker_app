import 'package:flutter/material.dart';
import 'package:timetracker_app/page_activities.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TimeTracker',
        // theme: LightTheme.lightTheme,
        // darkTheme: DarkTheme.darkTheme,
        home: const PageActivities(0));
  }
}
