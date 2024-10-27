import 'package:cloud_firestore/cloud_firestore.dart';

class LikedSongsManager {
  // Singleton pattern
  LikedSongsManager._privateConstructor();
  static final LikedSongsManager _instance = LikedSongsManager._privateConstructor();
  factory LikedSongsManager() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, String>> _likedSongs = [];
  Map<String, String>? _currentSong; // Store the current song
  String userId = ''; // Initialize userId to an empty string

  List<Map<String, String>> get likedSongs => _likedSongs;
  Map<String, String>? get currentSong => _currentSong;

  void setUserEmail(String email) {
    userId = email; // Set the userId to the provided email
  }

  Future<void> addSong(String title, String artist, String albumArt) async {
    if (userId.isEmpty) {
      throw Exception("User ID must be set before adding songs.");
    }

    if (!_likedSongs.any((song) => song['title'] == title)) {
      _likedSongs.add({
        'title': title,
        'artist': artist,
        'albumArt': albumArt,
      });

      // Save to Firestore
      await _firestore.collection('users').doc(userId).collection('liked_songs').add({
        'title': title,
        'artist': artist,
        'albumArt': albumArt,
        'timestamp': FieldValue.serverTimestamp(), // Optional
      });

      // Also save the liked songs list to the user document (optional)
      await _firestore.collection('users').doc(userId).set({
        'liked_songs': _likedSongs.map((song) => {
          'title': song['title'],
          'artist': song['artist'],
          'albumArt': song['albumArt'],
        }).toList(),
      }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
    }
  }

  Future<void> deleteSong(String title) async {
    if (userId.isEmpty) {
      throw Exception("User ID must be set before deleting songs.");
    }

    _likedSongs.removeWhere((song) => song['title'] == title);

    // Remove from Firestore
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('liked_songs')
        .where('title', isEqualTo: title)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Update the liked songs list in Firestore
    await _firestore.collection('users').doc(userId).set({
      'liked_songs': _likedSongs.map((song) => {
        'title': song['title'],
        'artist': song['artist'],
        'albumArt': song['albumArt'],
      }).toList(),
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
  }

  Future<void> setCurrentSong(String title, String artist, String albumArt) async {
    if (userId.isEmpty) {
      throw Exception("User ID must be set before setting the current song.");
    }

    _currentSong = {
      'title': title,
      'artist': artist,
      'albumArt': albumArt,
    };

    // Save current song to Firestore
    await _firestore.collection('users').doc(userId).set({
      'current_song': {
        'title': title,
        'artist': artist,
        'albumArt': albumArt,
      },
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
  }

  Future<void> loadLikedSongs() async {
    if (userId.isEmpty) {
      throw Exception("User ID must be set before loading liked songs.");
    }

    _likedSongs.clear();
    final snapshot = await _firestore.collection('users').doc(userId).collection('liked_songs').get();

    for (var doc in snapshot.docs) {
      _likedSongs.add(doc.data() as Map<String, String>? ?? {}); // Optional null check
    }
  }

  Future<void> loadCurrentSong() async {
    if (userId.isEmpty) {
      throw Exception("User ID must be set before loading the current song.");
    }

    final snapshot = await _firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      final currentSongData = snapshot.data()?['current_song'];
      if (currentSongData is Map<String, dynamic>) {
        _currentSong = {
          'title': currentSongData['title'] as String,
          'artist': currentSongData['artist'] as String,
          'albumArt': currentSongData['albumArt'] as String,
        };
      } else {
        _currentSong = null; // Set to null if not found
      }
    }
  }
}
