import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>(); // Form anahtarı ekleyin

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Giriş başarılıysa HomeScreen'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Firebase hatalarını ayırarak mesaj göster
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password provided for that user.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is badly formatted.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        // Genel hataları yakala
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log in: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Form anahtarını ayarla
          child: Column(
            children: [
              // Back Button at the top-left
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous page
                  },
                ),
              ),
              SizedBox(height: 30), // Space below the back button

              // "Log In" title at the top center
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Log In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40), // Space between the title and the input fields

              // Centered input fields and login button
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    // Email field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color(0xFF666666), // Background color for input fields
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Basit e-posta formatı kontrolü
                          final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color(0xFF666666), // Background color for input fields
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Space between fields and button

                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50), // Full width and specific height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      onPressed: _signIn,
                      child: Text(
                        'Log In',
                        style: TextStyle(fontSize: 16), // Increase font size
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
