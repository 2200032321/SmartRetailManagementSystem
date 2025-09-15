import 'package:flutter/material.dart';

class SupplierPage extends StatelessWidget {
  final String token;
  SupplierPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supplier Management')),
      body: Center(child: Text('Supplier management UI will appear here')),
    );
  }
}
