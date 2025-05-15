import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water_systerm/settings.dart';
import 'package:smart_water_systerm/statistics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AquariumControlPage extends StatefulWidget {
  const AquariumControlPage({super.key});

  @override
  State<AquariumControlPage> createState() => _AquariumControlPageState();
}

class _AquariumControlPageState extends State<AquariumControlPage> {
  int _selectedIndex = 0;
  String _greeting = "";
  
  // Sensor data variables
  double waterLevel = 0.0;
  double temperature = 0.0;
  double phQuality = 0.0;
  
  // Status variables
  bool isLoading = false;
  String errorMessage = '';
  DateTime lastUpdated = DateTime.now();
  
  // Timer for periodic updates
  Timer? _timer;
  
  // API endpoint - replace with your actual IoT device endpoint
  // Example: "http://192.168.1.100/api/sensors" for local network
  // Or use your IoT platform's API endpoint
  final String apiUrl = "http://10.244.144.122/api/sensors";

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    // Initial data fetch
    _fetchSensorData();
    
    // Set up periodic updates every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      _fetchSensorData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSensorData() async {
    // Don't fetch if we're already loading
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      // You can use a timeout to prevent long waiting times
      final response = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Parse your actual sensor data format here
          waterLevel = double.tryParse(data['water_level'].toString()) ?? waterLevel;
          temperature = double.tryParse(data['temperature'].toString()) ?? temperature;
          phQuality = double.tryParse(data['ph_quality'].toString()) ?? phQuality;
          lastUpdated = DateTime.now();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch sensor data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: $e';
        isLoading = false;
      });
    }
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = "Good Morning";
      } else if (hour < 17) {
        _greeting = "Good Afternoon";
      } else if (hour < 21) {
        _greeting = "Good Evening";
      } else {
        _greeting = "Good Night";
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatisticsScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  Future<void> sendCommand(String command) async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Send command to IoT device
      final response = await http.post(
        Uri.parse('$apiUrl/command'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'command': command})
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully sent "$command" command to device')),
        );
        // Fetch updated data after sending command
        _fetchSensorData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send command: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending command: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getLastUpdatedText() {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    if (difference.inSeconds < 60) {
      return 'Updated ${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return 'Updated ${difference.inMinutes} minutes ago';
    } else {
      return 'Updated ${difference.inHours} hours ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1A),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, size: 22),
                      SizedBox(width: 8),
                      Text("Home", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.analytics, size: 22),
                      SizedBox(width: 8),
                      Text("Analytics", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 ? Colors.orange : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.settings, size: 22),
                      SizedBox(width: 8),
                      Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$_greeting,",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Status indicator
                  Row(
                    children: [
                      // Show loading indicator or error icon
                      if (isLoading)
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 6),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        )
                      else if (errorMessage.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      Text(
                        _getLastUpdatedText(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Water level card
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Water",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          // Add manual refresh button
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: isLoading ? null : _fetchSensorData,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 100 * (waterLevel / 10), // Assuming 10 is max level
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(100),
                                          topRight: Radius.circular(100),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.blue[400],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Gal ${waterLevel.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Show loading overlay
                          if (isLoading)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Refill and Clean buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => sendCommand("refill"),
                      icon: const Icon(Icons.water_drop),
                      label: const Text("Refill Tank"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => sendCommand("clean"),
                      icon: const Icon(Icons.cleaning_services),
                      label: const Text("Clean Tank"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sensor readings
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${temperature.toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Temperature",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // Color indicator based on temperature
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: temperature > 30 ? Colors.red : 
                                       temperature > 25 ? Colors.orange : 
                                       temperature < 15 ? Colors.blue : 
                                       Colors.green,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          // Show loading overlay
                          if (isLoading)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                phQuality.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "PH Quality",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // Color indicator based on pH
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: phQuality > 8.5 ? Colors.red :
                                       phQuality < 6.5 ? Colors.red :
                                       phQuality > 8.0 ? Colors.orange :
                                       phQuality < 7.0 ? Colors.orange :
                                       Colors.green,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          // Show loading overlay
                          if (isLoading)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}