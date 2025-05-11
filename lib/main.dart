import 'package:flutter/material.dart';
import 'package:smart_water_systerm/statistics.dart';
import 'package:smart_water_systerm/dashboard.dart';
import 'package:smart_water_systerm/settings.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaSense',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        // Add dark theme configuration to match your app's style
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      // Initial route setup
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const AquariumControlPage(),
        '/statistics': (context) => const StatisticsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}