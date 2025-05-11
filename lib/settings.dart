import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water_systerm/statistics.dart';
import 'package:smart_water_systerm/dashboard.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes back button
      ),
      backgroundColor: const Color(0xFF1E1E1A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Settings section
          _buildSectionHeader('Account Settings'),
          _buildListTile('Personal Information', Icons.person_outline),
          _buildListTile('Notification', Icons.notifications_outlined),
          _buildListTile('Language', Icons.language_outlined),
          const Divider(height: 40, thickness: 1, color: Colors.grey),

          // Privacy & Security section
          _buildSectionHeader('Privacy & Security'),
          _buildListTile('Privacy Policy', Icons.privacy_tip_outlined),
          _buildListTile('Change Password', Icons.lock_outline),
          const Divider(height: 40, thickness: 1, color: Colors.grey),

          // Support section
          _buildSectionHeader('Support'),
          _buildListTile('Help & Support', Icons.help_outline),
          _buildListTile('Terms and conditions', Icons.description_outlined),
          _buildListTile('About', Icons.info_outline),
          const Divider(height: 40, thickness: 1, color: Colors.grey),

          // Account Action section
          _buildSectionHeader('Account Action'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Add logout functionality here
            },
          ),
        ],
      ),
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
            currentIndex: 2, // Settings is selected
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AquariumControlPage()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                );
              }
              // Index 2 is current screen (settings)
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.home, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Home",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.analytics, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Analytics",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.settings, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Settings",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Add navigation or functionality for each item
      },
    );
  }
}