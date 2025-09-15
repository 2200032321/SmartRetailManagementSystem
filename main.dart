import 'package:flutter/material.dart';
import 'package:srms_v4/screens/dashboard.dart';
import 'package:srms_v4/screens/login_screen.dart';


void main() {
  runApp(SRMSApp());
}

class SRMSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Retail Management System with AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboard': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return Dashboard(token: token);
        },
      },
    );
  }
}
