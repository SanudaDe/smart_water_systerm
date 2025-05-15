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
<<<<<<< HEAD
=======
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Information updated',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Passwords do not match',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Password changed successfully',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            child: Text(
              'Change',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                'Email Support',
                style: GoogleFonts.poppins(),
              ),
              subtitle: const Text('support@smartwater.com'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                'Call Support',
                style: GoogleFonts.poppins(),
              ),
              subtitle: const Text('+1 234 567 8900'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: Text(
                'Live Chat',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png', height: 80),
            const SizedBox(height: 16),
            Text(
              'Smart Water System v1.0.0',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2023 Smart Water System. All rights reserved.',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logout functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logged out successfully',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            child: Text(
              'Yes',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(),
        ),
        content: SingleChildScrollView(
          child: Text(
            '''Privacy Policy for Smart Water System

Effective Date: [Date]

At Smart Water System, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our water monitoring system.

1. Information We Collect

When you use Smart Water System, we may collect the following personal information:
- Name
- Email Address
- Device Information
- Usage Data

2. How We Use Your Information

We use your information to:
- Provide and maintain our service
- Notify you about changes to our service
- Allow you to participate in interactive features
- Provide customer support
- Gather analysis to improve our service
- Monitor usage of our service
- Detect and prevent technical issues

3. Data Security

We implement reasonable safeguards to protect your personal information from unauthorized access, use, or disclosure.

4. Your Choices

You can review, update, or delete your personal information by contacting us.

5. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

6. Contact Us

If you have any questions about this Privacy Policy, please contact us at support@smartwater.com''',
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms and Conditions',
          style: GoogleFonts.poppins(),
        ),
        content: SingleChildScrollView(
          child: Text(
            '''Terms and Conditions for Smart Water System

Effective Date: [Date]

Please read these Terms and Conditions ("Terms") carefully before using the Smart Water System app. By accessing or using the app, you agree to be bound by these Terms.

1. Use of the App
You agree to use the Smart Water System only for lawful purposes and in accordance with these Terms.

2. User Information
You are responsible for providing accurate and up-to-date information.

3. Intellectual Property
All content, branding, and features are the property of Smart Water System or its licensors.

4. Limitation of Liability
Smart Water System is not responsible for any direct or indirect damages resulting from use of the app.

5. Changes to Terms
We may update these Terms from time to time. Continued use of the app after changes means you accept the new Terms.

6. Governing Law
These Terms are governed by and interpreted in accordance with the laws of [Your Country/Region].

7. Contact Us
If you have any questions about these Terms, please contact us at support@smartwater.com''',
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
>>>>>>> 09f908f6127119bf43357904091479d1ba58c9b0
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
