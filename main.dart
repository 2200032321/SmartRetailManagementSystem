import 'package:flutter/material.dart';
import 'package:srms_v4/screens/dashboard.dart';
import 'package:srms_v4/screens/login_screen.dart';
import 'package:srms_v4/screens/splash_screen.dart'; // Import the splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Retail Management System with AI',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Updated to indigo for consistency
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // Login first
        '/splash': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return SplashScreen(token: token);
        },
        '/dashboard': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return Dashboard(token: token);
        },
      },
    );
  }
}
