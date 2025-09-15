import 'package:flutter/material.dart';

class AIRecommendationsPage extends StatelessWidget {
  final String token;
  AIRecommendationsPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Recommendations')),
      body: Center(child: Text('AI-powered product recommendations will appear here')),
    );
  }
}
