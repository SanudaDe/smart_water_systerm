import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'control.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaSense',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: DashboardPage(), // ✅ Go directly to dashboard
      routes: {'/control': (context) => ControlPage()},
    );
  }
}
