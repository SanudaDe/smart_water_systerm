import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Text(content, style: const TextStyle(color: Colors.grey)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1A),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            _buildTile(
              context,
              icon: Icons.person,
              label: "Edit Personal Info",
              onTap:
                  () => _showDialog(
                    context,
                    "Personal Info",
                    "You can edit name, email, and contact details here (UI only).",
                  ),
            ),

            _buildTile(
              context,
              icon: Icons.lock_outline,
              label: "Change Password",
              onTap:
                  () => _showDialog(
                    context,
                    "Change Password",
                    "Enter old password, new password and confirm (UI only).",
                  ),
            ),

            _buildTile(
              context,
              icon: Icons.privacy_tip_outlined,
              label: "Privacy Policy",
              onTap:
                  () => _showDialog(
                    context,
                    "Privacy Policy",
                    "Your data is safe. We do not share with any third party.",
                  ),
            ),

            _buildTile(
              context,
              icon: Icons.info_outline,
              label: "About App",
              onTap:
                  () => _showDialog(
                    context,
                    "About",
                    "Smart Water System v1.0.0\n\nDeveloped for real-time tank monitoring and control.",
                  ),
            ),

            _buildTile(
              context,
              icon: Icons.logout,
              label: "Logout",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully.")),
                );
              },
            ),

            const Spacer(),
            const Text(
              "© 2025 AquaSense. All rights reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
