import 'package:flutter/material.dart';

class CRMPage extends StatelessWidget {
  final String token;
  CRMPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Engagement / CRM')),
      body: Center(child: Text('CRM UI will appear here')),
    );
  }
}
