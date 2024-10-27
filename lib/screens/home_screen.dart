import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'playlist_screen1.dart';
import 'playlist_screen2.dart';
import 'playlist_screen3.dart';
import 'library_screen.dart';
import 'liked_songs_manager.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current tab index
  final likedSongsManager = LikedSongsManager(); // Create a single instance

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize pages with likedSongsManager
    _pages.addAll([
      HomeContent(likedSongsManager: likedSongsManager),
      SearchScreen(),
      LibraryScreen(userEmail: likedSongsManager.userId.toString(),),
    ]);
  }

  void _onBottomNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
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
          automaticallyImplyLeading: false,
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
        body: _pages[_currentIndex],
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
  final LikedSongsManager likedSongsManager; // Accept likedSongsManager as a parameter

  HomeContent({required this.likedSongsManager});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: likedSongsManager.loadCurrentSong(), // Load current song
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }

        return Column(
          children: [
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
                        likedSongsManager.currentSong!['albumArt']!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      likedSongsManager.currentSong!['title']!,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      likedSongsManager.currentSong!['artist']!,
                      style: TextStyle(color: Colors.white70),
                    ),
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
      },
    );
  }

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
