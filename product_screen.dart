import 'package:flutter/material.dart';
import 'package:srms_v4/models/product_model.dart';
import 'package:srms_v4/services/local_data_service.dart';


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = LocalDataService().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final product = data[index];
                return Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      "${product.category} - ₹${product.price} | Stock: ${product.stockQuantity}",
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
