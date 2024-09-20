import 'package:flutter/material.dart';
import 'package:spotify_klon/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
        apiKey: 'AIzaSyDHA0ashGOg44G5S9kNGrjot3_pLo27Aoo',
          appId: '1:934221727948:android:b2a462969b3dfa9db41a69',
        messagingSenderId: '934221727948',
        projectId: 'sample-firebase-ai-app-e77c9',
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
      home: SplashScreen(), // İlk açılışta splash ekranını gösterir.
    );
  }
}
