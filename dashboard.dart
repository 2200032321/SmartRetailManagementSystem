import 'package:flutter/material.dart';
import 'add_product.dart';
import 'view_products.dart';
import 'barcode_scanner.dart';
import 'supplier_page.dart';
import 'crm_page.dart';
import 'ai_recommendations.dart';
import 'chatbot_page.dart';
import 'billing_page.dart';
import 'analytics_page.dart';
import 'employee_page.dart';

class Dashboard extends StatelessWidget {
  final String token;
  Dashboard({required this.token});

  final List<Map<String, dynamic>> features = [
    {'title': 'Add Product', 'icon': Icons.add_box, 'page': AddProductPage, 'colors': [Colors.blue, Colors.lightBlueAccent]},
    {'title': 'View Products', 'icon': Icons.view_list, 'page': ViewProductsPage, 'colors': [Colors.green, Colors.lightGreenAccent]},
    {'title': 'Barcode Scanner', 'icon': Icons.qr_code_scanner, 'page': BarcodeScannerPage, 'colors': [Colors.orange, Colors.deepOrangeAccent]},
    {'title': 'Suppliers', 'icon': Icons.local_shipping, 'page': SupplierPage, 'colors': [Colors.purple, Colors.deepPurpleAccent]},
    {'title': 'CRM', 'icon': Icons.people, 'page': CRMPage, 'colors': [Colors.teal, Colors.tealAccent]},
    {'title': 'AI Recommendations', 'icon': Icons.smart_toy, 'page': AIRecommendationsPage, 'colors': [Colors.indigo, Colors.indigoAccent]},
    {'title': 'Chatbot', 'icon': Icons.chat_bubble, 'page': ChatbotPage, 'colors': [Colors.red, Colors.redAccent]},
    {'title': 'Billing', 'icon': Icons.receipt_long, 'page': BillingPage, 'colors': [Colors.cyan, Colors.cyanAccent]},
    {'title': 'Analytics', 'icon': Icons.analytics, 'page': AnalyticsPage, 'colors': [Colors.amber, Colors.amberAccent]},
    {'title': 'Employees', 'icon': Icons.badge, 'page': EmployeePage, 'colors': [Colors.pink, Colors.pinkAccent]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => feature['page'](token: token),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: feature['colors'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            feature['icon'],
                            size: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      feature['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
