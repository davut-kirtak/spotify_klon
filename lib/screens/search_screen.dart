import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'player_screen.dart'; // PlayerScreen'i import edin

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = []; // Deezer'dan dönen arama sonuçları
  bool _isLoading = false;

  Future<void> _search() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true; // Arama sırasında yükleme göstermek için
    });

    final url = Uri.parse('https://api.deezer.com/search?q=$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data['data']; // Şarkı sonuçlarını listeye ekleme
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _results = [];
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Koyu siyah arka plan
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Search', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Bir önceki sayfaya geri dön
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white), // Arama metin rengi beyaz
              decoration: InputDecoration(
                hintText: 'Search for songs...',
                hintStyle: TextStyle(color: Colors.grey[500]), // Yer tutucu rengi beyazımsı gri
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: _search,
                ),
                filled: true,
                fillColor: Colors.black54, // Daha koyu bir arka plan rengi
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Yükleniyor simgesi
                : Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final song = _results[index];
                  final albumArtUrl = song['album']['cover_big']; // Albüm kapağı URL'si
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        albumArtUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song['title'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      song['artist']['name'],
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    onTap: () {
                      // Şarkıya tıklandığında PlayerScreen'e yönlendir
                      final previewUrl = song['preview']; // Preview URL
                      if (previewUrl != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              songTitle: song['title'],
                              artistName: song['artist']['name'],
                              previewUrl: previewUrl,
                              albumArtUrl: albumArtUrl,
                            ),
                          ),
                        );
                      } else {
                        print('No preview available for this song.');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
