import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Color _getPhColor(double ph) {
    if (ph < 6.0 || ph > 8.0) return Colors.redAccent;
    if (ph >= 6.0 && ph <= 7.5) return Colors.green;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder sensor values
    double ph = 7.0;
    double temp = 25.0;
    double waterLevel = 75.0;
    String status = "System operating normally";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("AquaSense", style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome!", style: GoogleFonts.poppins(fontSize: 24)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sensorCard(
                  "💧",
                  "Water",
                  "${waterLevel.toStringAsFixed(1)}\"",
                  Colors.blue[300]!,
                ),
                _sensorCard(
                  "🌡️",
                  "Temp",
                  "${temp.toStringAsFixed(1)} °C",
                  Colors.orange[300]!,
                ),
                _sensorCard("⚗️", "pH", ph.toStringAsFixed(1), _getPhColor(ph)),
              ],
            ),
            const SizedBox(height: 30),
            _statusCard(status),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/control');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Controls",
          ),
        ],
      ),
    );
  }

  Widget _sensorCard(String icon, String label, String value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(color: color, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard(String status) {
    IconData icon = Icons.info_outline;
    Color color = Colors.blue;

    if (status.contains("Error") || status.contains("issue")) {
      icon = Icons.warning_amber_rounded;
      color = Colors.red;
    } else if (status.contains("cleaning")) {
      icon = Icons.cleaning_services_outlined;
      color = Colors.orange;
    }

    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          "Status",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(status, style: GoogleFonts.poppins()),
      ),
    );
  }
}
