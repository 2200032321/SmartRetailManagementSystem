import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillingPage extends StatefulWidget {
  final String token;
  const BillingPage({super.key, required this.token});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  List<Map<String, dynamic>> products = [];
  Map<String, dynamic>? selectedProduct;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      products = data.cast<Map<String, dynamic>>();
    });
  }

  double get totalPrice {
    if (selectedProduct == null) return 0.0;
    return ((selectedProduct!['price'] as num) * quantity).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButton<Map<String, dynamic>>(
              value: selectedProduct,
              hint: const Text("Choose a product"),
              isExpanded: true,
              items: products.map((product) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: product,
                  child: Text("${product['name']} - ₹${product['price']}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  quantity = 1;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Quantity:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Total Price: ₹${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedProduct == null
                  ? null
                  : () {
                // Billing submission logic goes here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Billed $quantity x ${selectedProduct!['name']} for ₹${totalPrice.toStringAsFixed(2)}"
                    ),
                  ),
                );
              },
              child: const Text("Generate Bill"),
            ),
          ],
        ),
      ),
    );
  }
}
