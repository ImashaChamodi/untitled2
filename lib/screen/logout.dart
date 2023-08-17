import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the home page after successful logout
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout error
      // ...
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showLogoutConfirmation(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Set the button color to green
          ),
          child: Text('Logout'),
        ),
      ),
    );
  }
}
