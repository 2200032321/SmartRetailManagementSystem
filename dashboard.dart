import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login_screen.dart';
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
        'title': 'Billing',
        'subtitle': 'Manage bills',
        'icon': Icons.receipt_long,
        'page': (String token) => BillingPage(token: token),
        'color': Colors.indigo,
      },
      {
        'title': 'View Products',
        'subtitle': 'All items',
        'icon': Icons.view_list,
        'page': (String token) => ViewProductsPage(token: token),
        'color': Colors.green,
      },
      {
        'title': 'Add Product',
        'subtitle': 'Add new stock',
        'icon': Icons.add_box,
        'page': (String token) => AddProductPage(token: token),
        'color': Colors.blue,
      },
      {
        'title': 'Barcode Scanner',
        'subtitle': 'Quick scan',
        'icon': Icons.qr_code_scanner,
        'page': (String token) => BarcodeScannerPage(token: token),
        'color': Colors.orange,
      },
      {
        'title': 'Analytics',
        'subtitle': 'Sales reports',
        'icon': Icons.analytics,
        'page': (String token) => AnalyticsPage(token: token),
        'color': Colors.amber,
      },
      {
        'title': 'CRM',
        'subtitle': 'Customer data',
        'icon': Icons.people,
        'page': (String token) => CRMPage(token: token),
        'color': Colors.teal,
      },
      {
        'title': 'Suppliers',
        'subtitle': 'Manage vendors',
        'icon': Icons.local_shipping,
        'page': (String token) => SupplierPage(token: token),
        'color': Colors.purple,
      },
      {
        'title': 'Employees',
        'subtitle': 'Staff details',
        'icon': Icons.badge,
        'page': (String token) => EmployeePage(token: token),
        'color': Colors.pink,
      },
      {
        'title': 'AI Recommendations',
        'subtitle': 'Smart insights',
        'icon': Icons.smart_toy,
        'page': (String token) => AIRecommendationsPage(token: token),
        'color': Colors.deepPurple,
      },
      {
        'title': 'Chatbot',
        'subtitle': 'Support bot',
        'icon': Icons.chat_bubble,
        'page': (String token) => ChatbotPage(token: token),
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Retail Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              final String title = feature['title'] as String;
              final String subtitle = feature['subtitle'] as String;
              final IconData icon = feature['icon'] as IconData;
              final Color color = feature['color'] as Color;
              final Function pageBuilder = feature['page'] as Function;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => pageBuilder(token)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(2, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(icon, size: 30, color: color),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
