import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import all your pages
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

class Dashboard extends StatefulWidget {
  final String token;
  final VoidCallback onLogout;

  const Dashboard({Key? key, required this.token, required this.onLogout})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  void _navigateTo(int idx) {
    setState(() => selectedIndex = idx);
  }

  static const Color navBarColor = Color(0xFF222b46);
  static const Color cardBackground = Colors.white;
  static const Color lightBg = Color(0xFFF7F8FA);

  // ✅ features list (taken from first code)
  List<Map<String, dynamic>> get features => [
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

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isWeb) {
          // ✅ Web Layout
          return Scaffold(
            backgroundColor: lightBg,
            body: Row(
              children: [
                // sidebar
                Container(
                  width: 210.0,
                  color: navBarColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 24.0),
                      const Text(
                        "Smart Retail",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32.0),
                      _sideNavItem(Icons.dashboard, "Dashboard",
                          selectedIndex == 0, () => _navigateTo(0)),
                      _sideNavItem(Icons.inventory, "Inventory",
                          selectedIndex == 1, () => _navigateTo(1)),
                      _sideNavItem(Icons.shopping_cart, "Sales",
                          selectedIndex == 2, () => _navigateTo(2)),
                      _sideNavItem(Icons.receipt_long, "Purchases",
                          selectedIndex == 3, () => _navigateTo(3)),
                      _sideNavItem(Icons.bar_chart, "Reports",
                          selectedIndex == 4, () => _navigateTo(4)),
                      const Spacer(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: const Text("Logout",
                            style:
                            TextStyle(color: Colors.white, fontSize: 17)),
                        onTap: widget.onLogout,
                      ),
                    ],
                  ),
                ),
                // content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: _getScreen(isWeb: true),
                  ),
                ),
              ],
            ),
          );
        } else {
          // ✅ Mobile Layout
          return Scaffold(
            appBar: AppBar(
              title: const Text("Smart Retail"),
              backgroundColor: navBarColor,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: widget.onLogout,
                ),
              ],
            ),
            backgroundColor: lightBg,
            body: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: _getScreen(isWeb: false),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: navBarColor,
              unselectedItemColor: Colors.grey[600],
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: _navigateTo,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.inventory), label: 'Inventory'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Sales'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long), label: 'Purchases'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Reports'),
              ],
            ),
          );
        }
      },
    );
  }

  // ✅ Switch between pages
  Widget _getScreen({required bool isWeb}) {
    if (selectedIndex == 0) {
      return _featuresGrid(); // features grid instead of placeholder
    } else {
      return Center(
        child: Text(
          "Page $selectedIndex coming soon...",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  // ✅ Grid of features
  Widget _featuresGrid() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              MaterialPageRoute(builder: (_) => pageBuilder(widget.token)),
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
    );
  }

  // ✅ Side navigation item (web)
  Widget _sideNavItem(
      IconData icon, String text, bool selected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: selected
          ? BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.0))
          : null,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 24.0),
        title: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 17.0)),
        onTap: onTap,
        selected: selected,
      ),
    );
  }
}
