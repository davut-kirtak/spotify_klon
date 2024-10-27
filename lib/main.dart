import 'package:flutter/material.dart';
import 'package:spotify_klon/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
        apiKey: 'YOUR API KEY',
          appId: 'YOUR API ID',
        messagingSenderId: ' SENDER ID',
        projectId: 'YOUR PROJECT ID',
    ),);

    runApp(SpotifyCloneApp());
  }



class SpotifyCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), 
    );
  }
}
