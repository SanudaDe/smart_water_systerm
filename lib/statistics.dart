import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('ph_data');
  late StreamSubscription<DatabaseEvent> _subscription;

  Map<String, Map<String, double>> weeklyPH =
      {}; // week => {product1, product2, product3}

  @override
  void initState() {
    super.initState();
    _listenToPHData();
  }

  void _listenToPHData() {
    _subscription = _dbRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      Map<String, Map<String, double>> parsedData = {};
      for (var week in data.keys) {
        final weekData = Map<String, dynamic>.from(data[week]);
        parsedData[week] = {
          'product1': double.tryParse(weekData['product1'].toString()) ?? 0.0,
          'product2': double.tryParse(weekData['product2'].toString()) ?? 0.0,
          'product3': double.tryParse(weekData['product3'].toString()) ?? 0.0,
        };
      }
      setState(() {
        weeklyPH = parsedData;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average PH In Your Tank',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Updated Weekly',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  weeklyPH.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          minY: 0,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget:
                                    (value, meta) => Text(
                                      value.toStringAsFixed(0),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final week = weeklyPH.keys.elementAt(
                                    value.toInt(),
                                  );
                                  return Text(
                                    week,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          barGroups:
                              weeklyPH.entries.map((entry) {
                                int index = weeklyPH.keys.toList().indexOf(
                                  entry.key,
                                );
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value['product1'] ?? 0,
                                      color: Colors.red,
                                      width: 7,
                                    ),
                                    BarChartRodData(
                                      toY: entry.value['product2'] ?? 0,
                                      color: Colors.lightBlue,
                                      width: 7,
                                    ),
                                    BarChartRodData(
                                      toY: entry.value['product3'] ?? 0,
                                      color: Colors.green,
                                      width: 7,
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Legend(color: Colors.red, label: 'Product 1'),
                Legend(color: Colors.lightBlue, label: 'Product 2'),
                Legend(color: Colors.green, label: 'Product 3'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
