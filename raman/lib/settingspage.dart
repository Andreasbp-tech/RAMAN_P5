import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        title: const Text('Indstillinger'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signOut(context),
          child: const Text('Log ud'),
        ),
      ),
    );
  }
}
