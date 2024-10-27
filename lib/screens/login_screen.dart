import 'package:flutter/material.dart';
import 'package:spotify_klon/screens/singup_screen.dart'; // Correct the import for the signup page
import 'package:spotify_klon/screens/login_screen_2.dart'; // Import the login screen 2

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF333333)], // Darker black to dark gray
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Logo and title at the top
              Image.asset('assets/images/spotify_logo.png', height: 100), // Ensure the correct height
              SizedBox(height: 20), // Space below the logo
              Text(
                'Spotify Clone',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40), // Space between title and buttons
              // Buttons at the bottom
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50), // Full width and specific height
                ),
                onPressed: () {
                  // Navigate to SignupScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(
                  'Ücretsiz Kaydol',
                  style: TextStyle(fontSize: 16), // Increase font size
                ),
              ),
              SizedBox(height: 10), // Space between buttons
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent, // No background color
                ),
                onPressed: () {
                  // Navigate to LoginScreen2
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen2()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10), // Adjust height
                  child: Center(
                    child: Text(
                      'Oturum Aç',
                      style: TextStyle(fontSize: 16), // Increase font size
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
