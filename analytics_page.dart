import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, dynamic> analytics = {};
  List products = [];
  bool loading = true;
  String errorMsg = '';
  int? touchedIndex; // For interactive pie chart

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    setState(() {
      loading = true;
      errorMsg = '';
    });

    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:5000/api/products"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        products = data;

        final totalProducts = products.length;
        final totalStock = products.fold<int>(
            0, (sum, p) => sum + ((p['stock_quantity'] ?? 0) as num).toInt());
        final avgPrice = products.fold<double>(
            0, (sum, p) => sum + ((p['price'] ?? 0) as num).toDouble()) /
            (totalProducts > 0 ? totalProducts : 1);

        setState(() {
          analytics = {
            'total_products': totalProducts,
            'total_stock': totalStock,
            'avg_price': avgPrice
          };
        });
      } else {
        setState(() {
          errorMsg = "Failed to fetch data. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = "Error fetching analytics data: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAnalyticsData,
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg.isNotEmpty
          ? Center(child: Text(errorMsg))
          : _analyticsContent(),
    );
  }

  Widget _analyticsContent() {
    final totalProducts = analytics["total_products"] ?? 0;
    final totalStock = analytics["total_stock"] ?? 0;
    final avgPrice = analytics["avg_price"] ?? 0.0;

    final topProducts = List.from(products);
    topProducts.sort((a, b) =>
        (b['stock_quantity'] ?? 0).compareTo(a['stock_quantity'] ?? 0));
    final topN = 5;
    final top5 = topProducts.take(topN).toList();
    final othersStock = topProducts.skip(topN).fold<int>(
        0, (sum, p) => sum + ((p['stock_quantity'] ?? 0) as num).toInt());

    final pieColors =
    List.generate(top5.length, (i) => Colors.primaries[i % Colors.primaries.length]);

    final pieSections = <PieChartSectionData>[];
    for (int i = 0; i < top5.length; i++) {
      final stock = (top5[i]['stock_quantity'] ?? 0) as int;
      pieSections.add(
        PieChartSectionData(
          value: stock.toDouble(),
          color: pieColors[i],
          radius: touchedIndex == i ? 60 : 50,
          showTitle: false,
        ),
      );
    }

    if (othersStock > 0) {
      pieSections.add(
        PieChartSectionData(
          value: othersStock.toDouble(),
          color: Colors.grey,
          radius: touchedIndex == top5.length ? 60 : 50,
          showTitle: false,
        ),
      );
    }

    String centerText = '';
    if (touchedIndex != null) {
      if (touchedIndex! < top5.length) {
        centerText =
        '${top5[touchedIndex!]['product_name']}\nStock: ${top5[touchedIndex!]['stock_quantity']}';
      } else {
        centerText = 'Others\nStock: $othersStock';
      }
    } else {
      centerText = 'Total Stock\n$totalStock';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Products: $totalProducts',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Total Stock: $totalStock',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Average Price: ₹${avgPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),

          const Text('Top 5 Products by Stock',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...top5.map((p) => ListTile(
            title: Text(p['product_name'] ?? ''),
            trailing: Text('Stock: ${p['stock_quantity']}'),
          )),
          const SizedBox(height: 16),

          const Text('Stock Distribution (Pie Chart)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: pieSections,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse != null &&
                          pieTouchResponse.touchedSection != null) {
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      } else {
                        touchedIndex = null;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                centerText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Price Distribution',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: LineChart(LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      int idx = value.toInt();
                      if (idx >= 0 && idx < products.length) {
                        return Text(
                          products[idx]['product_name'].toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    products.length,
                        (i) => FlSpot(
                      i.toDouble(),
                      (products[i]['price'] is num)
                          ? products[i]['price'].toDouble()
                          : double.tryParse(products[i]['price'].toString()) ?? 0,
                    ),
                  ),
                  isCurved: true,
                  barWidth: 2,
                  color: Colors.amber,
                  dotData: FlDotData(show: true),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
