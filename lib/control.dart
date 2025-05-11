import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  void sendCommand(String command, BuildContext context) {
    // Just show a message without sending to Firebase
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pretend sent "$command" command')));
  }

  Widget _commandButton(
    String label,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return ElevatedButton.icon(
      onPressed: () => sendCommand(label.toLowerCase(), context),
      icon: Icon(icon),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 30)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 150),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Tank Controls",
          style: GoogleFonts.poppins(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _commandButton(
              "REFILL",
              Icons.water_drop,
              Colors.blueAccent,
              context,
            ),
            const SizedBox(height: 20),
            _commandButton(
              "CLEAN",
              Icons.cleaning_services,
              Colors.orange,
              context,
            ),
            const SizedBox(height: 20),
            _commandButton(
              "FLUSH",
              Icons.wash_rounded,
              Colors.redAccent,
              context,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/');
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
}