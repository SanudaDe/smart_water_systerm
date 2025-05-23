import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Water System',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const MainScreen(), // ← uses the navigation container
    );
  }
}
