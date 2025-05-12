import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water_systerm/dashboard.dart';
import 'package:smart_water_systerm/settings.dart';
import 'package:fl_chart/fl_chart.dart';

// Define a model class for pH reading data
class PHReading {
  final double product1Value;
  final double product2Value;
  final double product3Value;
  final DateTime timestamp;

  PHReading({
    required this.product1Value,
    required this.product2Value,
    required this.product3Value,
    required this.timestamp,
  });
}

// Service class to handle communication with IoT device/sensor
class PHSensorService {
  // This would be connected to your actual IoT sensor
  // For now, we'll simulate data with a stream controller
  static final StreamController<PHReading> _phStreamController = StreamController<PHReading>.broadcast();
  
  // Expose stream to listen for pH updates
  static Stream<PHReading> get phStream => _phStreamController.stream;

  // Method to add new reading (this would be called by your IoT connection)
  static void addReading(PHReading reading) {
    _phStreamController.add(reading);
  }

  // Method to close stream when done
  static void dispose() {
    _phStreamController.close();
  }

  // For testing/demo purposes - simulate sensor data
  static void startMockSensor() {
    // Simulate a reading every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // Generate some fluctuating values
      final now = DateTime.now();
      final baseValue = 6.8 + (now.second % 10 - 5) / 10; // Fluctuate around 6.8
      
      addReading(PHReading(
        product1Value: baseValue + 0.2,
        product2Value: baseValue,
        product3Value: baseValue - 0.3,
        timestamp: now,
      ));
    });
  }
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedIndex = 1; // Analytics is selected
  
  // Store pH readings history
  final List<PHReading> _readings = [];
  // Store current pH value
  double _currentPHValue = 6.8;
  
  // Maximum number of readings to show on chart
  final int _maxReadingsToShow = 9;
  
  // Subscription to pH readings stream
  late StreamSubscription<PHReading> _subscription;

  @override
  void initState() {
    super.initState();
    
    // Start listening to pH readings
    _subscription = PHSensorService.phStream.listen(_onNewReading);
    
    // Start mock sensor for demo (remove this in production and connect to real sensor)
    PHSensorService.startMockSensor();
  }
  
  @override
  void dispose() {
    // Cancel subscription when screen is disposed
    _subscription.cancel();
    super.dispose();
  }
  
  // Handle new pH reading
  void _onNewReading(PHReading reading) {
    setState(() {
      // Add to readings history
      _readings.add(reading);
      
      // Limit number of readings to show
      if (_readings.length > _maxReadingsToShow) {
        _readings.removeAt(0);
      }
      
      // Update current pH value (using product2 as the main reading)
      _currentPHValue = reading.product2Value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AquariumControlPage()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }else if (index == 1) {
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
              Text(
                "Statistics",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Daily Usage Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Usage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: 0.72,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey[800],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                              Center(
                                child: Text(
                                  '72%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Modified: Live PH Chart and Quantity Test in a row
              Row(
                children: [
                  // PH Chart Card - Expanded to take more space
                  Expanded(
                    flex: 3, // Gives this container more space
                    child: Container(
                      height: 240, // Fixed height for the chart
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with info icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Average PH In Your Tank',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF3A3A3A),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            
                            // PH Value - Now shows live value
                            Row(
                              children: [
                                Text(
                                  _currentPHValue.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _getPHStatusColor(_currentPHValue),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Live indicator dot
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            
                            Text(
                              _getPHStatusText(_currentPHValue),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            
                            // Chart - Now using real-time data
                            Expanded(
                              child: _readings.isEmpty
                                  ? const Center(child: CircularProgressIndicator())
                                  : PHBarChart(readings: _readings),
                            ),
                            
                            // Legend
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _LegendItem(color: Colors.red, label: 'Product 1'),
                                SizedBox(width: 8),
                                _LegendItem(color: Colors.green, label: 'Product 2'),
                                SizedBox(width: 8),
                                _LegendItem(color: Colors.blue, label: 'Product 3'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Quantity Test Card
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity test',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '3',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to determine pH status text
  String _getPHStatusText(double ph) {
    if (ph < 6.0) return 'Too acidic';
    if (ph > 8.0) return 'Too alkaline';
    if (ph >= 6.5 && ph <= 7.5) return 'Optimal range';
    return 'Acceptable';
  }
  
  // Helper method to determine pH status color
  Color _getPHStatusColor(double ph) {
    if (ph < 6.0 || ph > 8.0) return Colors.red;
    if (ph >= 6.5 && ph <= 7.5) return Colors.green;
    return Colors.orange;
  }

}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  
  const _LegendItem({
    required this.color,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class PHBarChart extends StatelessWidget {
  final List<PHReading> readings;
  
  const PHBarChart({
    required this.readings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        minY: 0, // Updated to start from 0 since pH is typically 0-14
        groupsSpace: 12,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String product;
              switch (rodIndex) {
                case 0:
                  product = 'Product 1';
                  break;
                case 1:
                  product = 'Product 2';
                  break;
                case 2:
                  product = 'Product 3';
                  break;
                default:
                  product = 'Unknown';
              }
              return BarTooltipItem(
                '$product: ${rod.toY.toStringAsFixed(1)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < readings.length) {
                  // Format timestamp as short time
                  final time = readings[index].timestamp;
                  return Text(
                    '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xFF3A3A3A),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xFF3A3A3A),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: _getBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(readings.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: readings[index].product1Value,
            color: Colors.red,
            width: 3,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: readings[index].product2Value,
            color: Colors.green,
            width: 3,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: readings[index].product3Value,
            color: Colors.blue,
            width: 3,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }
}