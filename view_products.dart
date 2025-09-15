import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewProductsPage extends StatefulWidget {
  final String token;
  ViewProductsPage({required this.token});

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
        print('Error: ${response.body}');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Products')),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p['name']),
                subtitle: Text('Price: ${p['price']}, Barcode: ${p['barcode']}'),
              );
            }));
  }
}
