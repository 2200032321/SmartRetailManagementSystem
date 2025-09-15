import 'package:flutter/material.dart';

class EmployeePage extends StatelessWidget {
  final String token;
  EmployeePage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee & Operations')),
      body: Center(child: Text('Employee and operations management UI will appear here')),
    );
  }
}
