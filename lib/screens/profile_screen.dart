import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Import the login screen

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            SizedBox(height: 20),

            // Username
            Text(
              user?.displayName ?? 'Username',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Email
            Text(
              user?.email ?? 'Email',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 30),

            // Log Out Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Text color
                minimumSize: Size(double.infinity, 50), // Full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log out: ${e.toString()}')),
                  );
                }
              },
              child: Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
