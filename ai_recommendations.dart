import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class AIRecommendationsPage extends StatefulWidget {
  final String token;
  const AIRecommendationsPage({super.key, required this.token});

  @override
  State<AIRecommendationsPage> createState() => _AIRecommendationsPageState();
}

class _AIRecommendationsPageState extends State<AIRecommendationsPage> {
  List products = [];
  bool loading = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchAIRecommendations();
  }

  Future<void> fetchAIRecommendations() async {
    setState(() {
      loading = true;
      errorMsg = '';
    });

    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:5000/api/ai/recommendations"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        data.sort((a, b) {
          final priceA = (a['recommended_price'] is num)
              ? a['recommended_price'] as num
              : double.tryParse(a['recommended_price'].toString()) ?? 0;
          final priceB = (b['recommended_price'] is num)
              ? b['recommended_price'] as num
              : double.tryParse(b['recommended_price'].toString()) ?? 0;
          return priceB.compareTo(priceA);
        });

        setState(() {
          products = data.take(5).toList();
        });
      } else {
        setState(() {
          errorMsg = "Failed to fetch data. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = "Error fetching AI recommendations: $e";
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
        title: const Text('AI Recommendations'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAIRecommendations,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg.isNotEmpty
          ? Center(child: Text(errorMsg))
          : products.isEmpty
          ? const Center(child: Text('No recommendations available'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];

          final forecastPrices = p['forecast_prices'] ?? [];
          final forecastDemand = p['forecast_demand'] ?? [];

          final priceSpots = List.generate(
            forecastPrices.length,
                (i) => FlSpot(
              i.toDouble(),
              (forecastPrices[i]['price'] is num)
                  ? forecastPrices[i]['price'].toDouble()
                  : double.tryParse(
                  forecastPrices[i]['price'].toString()) ??
                  0,
            ),
          );

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                        Colors.deepPurple.shade100,
                        child: Text(
                          (p['name'] ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name'] ?? 'Unknown',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                                "Current: ₹${p['current_price'] ?? 0} | Stock: ${p['stock_quantity'] ?? 0}"),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Price Forecast (7 days)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 120,
                    child: priceSpots.isEmpty
                        ? const Center(
                        child: Text("No forecast data"))
                        : LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                int idx = value.toInt();
                                if (idx >= 0 &&
                                    idx <
                                        forecastPrices
                                            .length) {
                                  return Text(
                                    forecastPrices[idx]
                                    ['date']
                                        .toString()
                                        .substring(5),
                                    style: const TextStyle(
                                        fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: true),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: priceSpots,
                            isCurved: true,
                            barWidth: 2,
                            color: Colors.deepPurple,
                            dotData: FlDotData(show: true),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Demand Forecast (7 days)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 120,
                    child: forecastDemand.isEmpty
                        ? const Center(
                        child: Text("No demand data"))
                        : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                int idx = value.toInt();
                                if (idx >= 0 &&
                                    idx < forecastDemand.length) {
                                  return Text(
                                    forecastPrices[idx]
                                    ['date']
                                        .toString()
                                        .substring(5),
                                    style: const TextStyle(
                                        fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: true),
                          ),
                        ),
                        barGroups: List.generate(
                          forecastDemand.length,
                              (i) => BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: (forecastDemand[i] is num)
                                    ? forecastDemand[i].toDouble()
                                    : double.tryParse(
                                    forecastDemand[i].toString()) ??
                                    0,
                                color: Colors.orange,
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Recommended Price: ₹${p['recommended_price'] ?? 0}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
