import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CRMPage extends StatefulWidget {
  final String token;
  const CRMPage({super.key, required this.token});

  @override
  State<CRMPage> createState() => _CRMPageState();
}

class _CRMPageState extends State<CRMPage> {
  List customers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    setState(() => loading = true);
    try {
      final String response =
      await rootBundle.loadString('data/customers.json');
      final data = await json.decode(response);
      setState(() => customers = data);
    } catch (e) {
      print('Error loading customers: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM - Customers'),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : customers.isEmpty
          ? const Center(child: Text('No customers available'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final cust = customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  cust['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                cust['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Email: ${cust['email']}\nPhone: ${cust['phone']}\nTotal Purchase: ₹${cust['total_purchase']}\nLoyalty Points: ${cust['loyalty_points']}"),
            ),
          );
        },
      ),
    );
  }
}
