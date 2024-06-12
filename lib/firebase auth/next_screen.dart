import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(
          context, ModalRoute.withName('/')); // Go back to the login screen
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Color.fromARGB(255, 237, 237, 255)),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the next screen!'),
      ),
    );
  }
}
