import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  final String token;
  AnalyticsPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics & Reports')),
      body: Center(child: Text('Analytics and reports UI will appear here')),
    );
  }
}
