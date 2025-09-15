import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  final String token;
  BillingPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Billing & Payments')),
      body: Center(child: Text('Billing and payment UI will appear here')),
    );
  }
}
