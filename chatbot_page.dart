import 'package:flutter/material.dart';

class ChatbotPage extends StatelessWidget {
  final String token;
  ChatbotPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot Support')),
      body: Center(child: Text('Chatbot support UI will appear here')),
    );
  }
}
