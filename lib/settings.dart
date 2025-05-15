import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: GoogleFonts.poppins()),
            content: Text(content, style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF1E1E1A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white),
            title: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap:
                () => _showDialog(
                  'Edit Profile',
                  'User info feature under development.',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.white),
            title: Text(
              'Change Password',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap:
                () => _showDialog(
                  'Change Password',
                  'Password update feature under development.',
                ),
          ),

          const Divider(color: Colors.grey, height: 32),

          _buildSectionHeader('App Info'),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.white),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap:
                () => _showDialog(
                  'Privacy Policy',
                  'This app does not collect personal data.',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: Text(
              'About',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap:
                () => _showDialog(
                  'About',
                  'AquaSense v1.0.0\nDeveloped by Your Team.',
                ),
          ),

          const Divider(color: Colors.grey, height: 32),

          _buildSectionHeader('Actions'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logged out successfully',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
          ),
        ],
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
}
