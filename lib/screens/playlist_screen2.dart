import 'dart:convert';
import 'dart:math'; // `dart:random` yerine `dart:math` kullanın
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'player_screen.dart';

class PlaylistScreen2 extends StatefulWidget {
  @override
  _PlaylistScreen2State createState() => _PlaylistScreen2State();
}

class _PlaylistScreen2State extends State<PlaylistScreen2> {
  List<dynamic> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs('Rock Playlist'); //
  }

  Future<void> fetchSongs(String query) async {
    final url = Uri.parse('https://api.deezer.com/search?q=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> allResults = data['data'];

        // Select 10 random songs
        final random = Random();
        List<dynamic> randomSongs = [];
        if (allResults.length > 10) {
          while (randomSongs.length < 10) {
            var song = allResults[random.nextInt(allResults.length)];
            if (!randomSongs.contains(song)) {
              randomSongs.add(song);
            }
          }
        } else {
          randomSongs = allResults; // Return all results if less than 10
        }

        setState(() {
          _songs = randomSongs;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _songs = [];
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Rock Playlist',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _songs.isEmpty
          ? Center(child: Text('No songs found', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  song['album']['cover_small'],
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
              title: Text(
                song['title'],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                song['artist']['name'],
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      songTitle: song['title'],
                      artistName: song['artist']['name'],
                      previewUrl: song['preview'],
                      albumArtUrl: song['album']['cover_big'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
