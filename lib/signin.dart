import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_water_systerm/dashboard.dart';

class Google extends StatefulWidget {
  const Google({super.key});

  @override
  State<Google> createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _handleInitialCheck();
  }

  Future<void> _handleInitialCheck() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _goToDashboard();
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _goToDashboard();
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  void _goToDashboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AquariumControlPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ElevatedButton.icon(
              icon: Image.asset('images/google.png', height: 24, width: 24),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              onPressed: _signInWithGoogle,
            ),
          ),
        );
      },
    );
  }
}
