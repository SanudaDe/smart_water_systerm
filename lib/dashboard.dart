import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double waterLevelPercent = 0.0;
  double temperature = 0.0;
  double phQuality = 0.0;
  String tankStatus = "Loading...";
  Timer? _timer;

  final String firebaseUrl =
      'https://smart-water-systerm-default-rtdb.firebaseio.com/smart_tank.json';
  final String washMotorUrl =
      'https://smart-water-systerm-default-rtdb.firebaseio.com/smart_tank/wash_motor.json';

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchSensorData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distance = double.tryParse(data['distance'].toString()) ?? 27.0;
        final tempF = double.tryParse(data['temperature'].toString()) ?? 0.0;
        final tempC = (tempF - 32) * 5 / 9; // Convert Fahrenheit to Celsius
        final ph = double.tryParse(data['ph'].toString()) ?? 0.0;
        final status = data['pump_status'] ?? "Unknown";

        setState(() {
          waterLevelPercent = _convertDistanceToPercentage(distance);
          temperature = tempC;
          phQuality = ph;
          tankStatus =
              status == "ON"
                  ? "Filling..."
                  : (waterLevelPercent >= 95 ? "Full" : "Normal");
        });
      } else {
        debugPrint('Failed to load Firebase data');
      }
    } catch (e) {
      debugPrint('Error fetching Firebase data: $e');
    }
  }

  double _convertDistanceToPercentage(double distance) {
    const double emptyCM = 27.0;
    const double fullCM = 9.0;

    if (distance >= emptyCM) return 0.0;
    if (distance <= fullCM) return 100.0;

    return ((emptyCM - distance) / (emptyCM - fullCM)) * 100;
  }

  Future<void> triggerWasherMotor() async {
    try {
      final response = await http.put(
        Uri.parse(washMotorUrl),
        body: json.encode("ON"),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🌀 Washer motor triggered")),
        );
      } else {
        throw Exception("Failed to update Firebase");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  Widget _buildSensorCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Tank Diagram (placeholder)",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          Icon(Icons.auto_graph, size: 48, color: Colors.blueAccent),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Smart Water Tank',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSensorCard(
              "Water Level",
              "${waterLevelPercent.toStringAsFixed(1)}%",
              Icons.water_drop,
            ),
            const SizedBox(height: 20),
            _buildSensorCard(
              "Temperature",
              "${temperature.toStringAsFixed(1)} °C",
              Icons.thermostat,
            ),
            const SizedBox(height: 20),
            _buildSensorCard("pH Quality", "$phQuality", Icons.science),
            const SizedBox(height: 20),
            _buildSensorCard("Tank Status", tankStatus, Icons.info),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: triggerWasherMotor,
              icon: const Icon(Icons.cleaning_services),
              label: const Text("Clean"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
            _buildDiagram(),
          ],
        ),
      ),
    );
  }
}
