import 'package:flutter/material.dart';
import 'search_screen.dart'; // Ensure this import matches the location of your SearchScreen
import 'profile_screen.dart'; // Ensure this import matches the location of your ProfileScreen
import 'playlist_screen1.dart'; // Import PlaylistScreen1
import 'playlist_screen2.dart'; // Import PlaylistScreen2
import 'playlist_screen3.dart'; // Import PlaylistScreen3
import 'library_screen.dart'; // Import LibraryScreen
import 'liked_songs_manager.dart'; // Import LikedSongsManager
import 'player_screen.dart'; // Import PlayerScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current tab index

  final List<Widget> _pages = [
    HomeContent(), // Ensure this widget is correctly implemented
    SearchScreen(), // Search Screen
    LibraryScreen(), // Library Screen
  ];

  void _onBottomNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      } else if (index == 0 && _currentIndex != 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Spotify Clone', style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: false, // Remove back button
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: _pages[_currentIndex], // Display the current page
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: _onBottomNavBarTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final likedSongsManager = LikedSongsManager(); // Access the LikedSongsManager

    return Column(
      children: [
        // Featured Playlists or Albums
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Featured Playlists',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPlaylistCard(context, 'Popular', 'assets/playlist1.jpg', PlaylistScreen1()),
              _buildPlaylistCard(context, 'Rock', 'assets/playlist2.jpg', PlaylistScreen2()),
              _buildPlaylistCard(context, 'Indie', 'assets/playlist3.jpg', PlaylistScreen3()),
            ],
          ),
        ),
        // Recently Played Section
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recently Played',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: likedSongsManager.currentSong != null
              ? ListView(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    likedSongsManager.currentSong!['albumArt']!, // Fetch the album art from the current song
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  likedSongsManager.currentSong!['title']!, // Song title
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  likedSongsManager.currentSong!['artist']!, // Artist name
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        songTitle: likedSongsManager.currentSong!['title']!,
                        artistName: likedSongsManager.currentSong!['artist']!,
                        previewUrl: likedSongsManager.currentSong!['previewUrl'] ?? '',
                        albumArtUrl: likedSongsManager.currentSong!['albumArt']!,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
              : Center(
            child: Text(
              'No recently played songs',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Playlist card widget
  Widget _buildPlaylistCard(BuildContext context, String title, String imagePath, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
