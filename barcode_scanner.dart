import 'package:flutter/material.dart';

class BarcodeScannerPage extends StatelessWidget {
  final String token;
  BarcodeScannerPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barcode Scanner')),
      body: Center(child: Text('Barcode Scanner UI will appear here')),
    );
  }
}
