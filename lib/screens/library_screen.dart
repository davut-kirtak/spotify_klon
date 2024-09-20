import 'package:flutter/material.dart';
import 'liked_songs_manager.dart'; // Import the manager
import 'player_screen.dart'; // Import the PlayerScreen

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late LikedSongsManager _manager;
  late List<Map<String, String>> _likedSongs;

  @override
  void initState() {
    super.initState();
    _manager = LikedSongsManager();
    _likedSongs = _manager.likedSongs;
  }

  void _removeSong(String title) {
    setState(() {
      _manager.deleteSong(title);
      _likedSongs = _manager.likedSongs;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Song removed from your library')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove the back button
        title: Text('Library', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Library',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _likedSongs.length,
              itemBuilder: (context, index) {
                final song = _likedSongs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      song['albumArt']!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song['title']!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    song['artist']!,
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      _removeSong(song['title']!);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          songTitle: song['title']!,
                          artistName: song['artist']!,
                          previewUrl: song['previewUrl'] ?? '', // Update with actual URL if available
                          albumArtUrl: song['albumArt']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
