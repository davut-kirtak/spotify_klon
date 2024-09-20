// liked_songs_manager.dart
class LikedSongsManager {
  // Singleton pattern
  LikedSongsManager._privateConstructor();
  static final LikedSongsManager _instance = LikedSongsManager._privateConstructor();
  factory LikedSongsManager() {
    return _instance;
  }

  final List<Map<String, String>> _likedSongs = [];
  Map<String, String>? _currentSong; // Store the current song

  List<Map<String, String>> get likedSongs => _likedSongs;
  Map<String, String>? get currentSong => _currentSong;

  void addSong(String title, String artist, String albumArt) {
    if (!_likedSongs.any((song) => song['title'] == title)) {
      _likedSongs.add({
        'title': title,
        'artist': artist,
        'albumArt': albumArt,
      });
    }
  }

  void deleteSong(String title) {
    _likedSongs.removeWhere((song) => song['title'] == title);
  }

  void setCurrentSong(String title, String artist, String albumArt) {
    _currentSong = {
      'title': title,
      'artist': artist,
      'albumArt': albumArt,
    };
    // No automatic addition to liked songs
  }
}
