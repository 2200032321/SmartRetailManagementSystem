import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIRecommendationsPage extends StatefulWidget {
  final String token;
  const AIRecommendationsPage({super.key, required this.token});

  @override
  State<AIRecommendationsPage> createState() => _AIRecommendationsPageState();
}

class _AIRecommendationsPageState extends State<AIRecommendationsPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loading = true);
    try {
      final String response =
      await rootBundle.loadString('data/products.json');
      final data = await json.decode(response);
      // Example: Top 5 expensive products as recommendations
      data.sort((a, b) => (b['price']).compareTo(a['price']));
      setState(() => products = data.take(5).toList());
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        backgroundColor: Colors.indigo,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No recommendations available'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Text(
                  p['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                p['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Price: ₹${p['price']} | Stock: ${p['stock_quantity']}"),
            ),
          );
        },
      ),
    );
  }
}
