import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewProductsPage extends StatefulWidget {
  final String token;
  const ViewProductsPage({super.key, required this.token});

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => loading = true);
    final url = Uri.parse('http://localhost:3000/api/products');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        setState(() => products = jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch products')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(
        child: Text(
          "No products available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchProducts,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Price: ₹${p['price']} | Barcode: ${p['barcode']}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
