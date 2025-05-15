import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_water_systerm/signin.dart';
import 'package:smart_water_systerm/statistics.dart';
import 'package:smart_water_systerm/dashboard.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Personal Information', style: GoogleFonts.poppins()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
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
                child: Text('Save', style: GoogleFonts.poppins()),
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
      builder:
          (context) => AlertDialog(
            title: Text('Change Password', style: GoogleFonts.poppins()),
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
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
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
                child: Text('Change', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Help & Support', style: GoogleFonts.poppins()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('Email Support', style: GoogleFonts.poppins()),
                  subtitle: const Text('support@smartwater.com'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text('Call Support', style: GoogleFonts.poppins()),
                  subtitle: const Text('+1 234 567 8900'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: Text('Live Chat', style: GoogleFonts.poppins()),
                  onTap: () {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('About', style: GoogleFonts.poppins()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlutterLogo(size: 80),
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
                child: Text('Close', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  void _showLogoutConfirm() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Log Out', style: GoogleFonts.poppins()),
            content: Text(
              'Are you sure you want to log out?',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  signOutAndRedirect(context);
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
      builder:
          (context) => AlertDialog(
            title: Text('Privacy Policy', style: GoogleFonts.poppins()),
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
                child: Text('Close', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Terms and Conditions', style: GoogleFonts.poppins()),
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
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF1E1E1A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Settings section
          _buildSectionHeader('Account Settings'),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white),
            title: Text(
              'Personal Information',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showPersonalInfoDialog,
          ),

          // Privacy & Security section
          _buildSectionHeader('Privacy & Security'),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showPrivacyPolicy,
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.white),
            title: Text(
              'Change Password',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(height: 40, thickness: 1, color: Colors.grey),

          // Support section
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: Text(
              'Help & Support',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showHelpSupportDialog,
          ),
          ListTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Terms and conditions',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showTerms,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: Text(
              'About',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showAboutDialog,
          ),
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
            onTap: _showLogoutConfirm,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AquariumControlPage(),
                  ),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              }
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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

  Future<void> signOutAndRedirect(BuildContext context) async {
    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error during sign-out: $e');
    }
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
