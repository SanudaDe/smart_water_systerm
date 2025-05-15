import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double waterLevel = 0.0;
  double temperature = 0.0;
  double phQuality = 0.0;
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
        setState(() {
          waterLevel = double.tryParse(data['distance'].toString()) ?? 0.0;
          temperature = double.tryParse(data['temperature'].toString()) ?? 0.0;
          phQuality = double.tryParse(data['ph'].toString()) ?? 0.0;
        });
      } else {
        debugPrint('Failed to load Firebase data');
      }
    } catch (e) {
      debugPrint('Error fetching Firebase data: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1A),
      appBar: AppBar(
        title: const Text('Smart Water Tank'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSensorCard("Water Level", "$waterLevel cm", Icons.water_drop),
            const SizedBox(height: 20),
            _buildSensorCard(
              "Temperature",
              "$temperature °C",
              Icons.thermostat,
            ),
            const SizedBox(height: 20),
            _buildSensorCard("pH Quality", "$phQuality", Icons.science),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Future refill logic
                  },
                  icon: const Icon(Icons.water),
                  label: const Text("Refill"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: triggerWasherMotor,
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text("Clean"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}
