import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupplierPage extends StatefulWidget {
  final String token;
  const SupplierPage({super.key, required this.token});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List suppliers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    setState(() => loading = true);
    try {
      final String response =
      await rootBundle.loadString('data/suppliers.json');
      final data = await json.decode(response);
      setState(() => suppliers = data);
    } catch (e) {
      print('Error loading suppliers: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        backgroundColor: Colors.purple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : suppliers.isEmpty
          ? const Center(child: Text('No suppliers available'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final s = suppliers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  s['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                s['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Email: ${s['email']}\nPhone: ${s['phone']}\nProducts: ${s['products_supplied'].join(', ')}"),
            ),
          );
        },
      ),
    );
  }
}
