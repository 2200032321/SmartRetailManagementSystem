import 'package:flutter/material.dart';
import 'package:srms_v4/screens/login_screen.dart';
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
  const Dashboard({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Add Product',
        'icon': Icons.add_box,
        'page': (String token) => AddProductPage(token: token),
        'colors': [Colors.blue, Colors.lightBlueAccent]
      },
      {
        'title': 'View Products',
        'icon': Icons.view_list,
        'page': (String token) => ViewProductsPage(token: token),
        'colors': [Colors.green, Colors.lightGreenAccent]
      },
      {
        'title': 'Barcode Scanner',
        'icon': Icons.qr_code_scanner,
        'page': (String token) => BarcodeScannerPage(token: token),
        'colors': [Colors.orange, Colors.deepOrangeAccent]
      },
      {
        'title': 'Suppliers',
        'icon': Icons.local_shipping,
        'page': (String token) => SupplierPage(token: token),
        'colors': [Colors.purple, Colors.deepPurpleAccent]
      },
      {
        'title': 'CRM',
        'icon': Icons.people,
        'page': (String token) => CRMPage(token: token),
        'colors': [Colors.teal, Colors.tealAccent]
      },
      {
        'title': 'AI Recommendations',
        'icon': Icons.smart_toy,
        'page': (String token) => AIRecommendationsPage(token: token),
        'colors': [Colors.indigo, Colors.indigoAccent]
      },
      {
        'title': 'Chatbot',
        'icon': Icons.chat_bubble,
        'page': (String token) => ChatbotPage(token: token),
        'colors': [Colors.red, Colors.redAccent]
      },
      {
        'title': 'Billing',
        'icon': Icons.receipt_long,
        'page': (String token) => BillingPage(token: token),
        'colors': [Colors.cyan, Colors.cyanAccent]
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics,
        'page': (String token) => AnalyticsPage(token: token),
        'colors': [Colors.amber, Colors.amberAccent]
      },
      {
        'title': 'Employees',
        'icon': Icons.badge,
        'page': (String token) => EmployeePage(token: token),
        'colors': [Colors.pink, Colors.pinkAccent]
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Retail Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85, // 🔹 smaller cards
          ),
          itemBuilder: (context, index) {
            final feature = features[index];

            final String title = feature['title'] as String;
            final IconData icon = feature['icon'] as IconData;
            final List<Color> colors = feature['colors'] as List<Color>;
            final Function pageBuilder = feature['page'] as Function;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pageBuilder(token),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 42, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
