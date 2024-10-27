import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  final String userEmail;

  LibraryScreen({required this.userEmail});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Map<String, dynamic>>> likedSongs;

  @override
  void initState() {
    super.initState();
    likedSongs = fetchLikedSongs();
  }

  Future<List<Map<String, dynamic>>> fetchLikedSongs() async {
    List<Map<String, dynamic>> songsList = [];

    try {
      // Kullanıcının email adresine göre liked_songs'u çek
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail) // Kullanıcının email'ini doküman ID'si olarak kullan
          .collection('liked_songs')
          .get();

      for (var doc in snapshot.docs) {
        // Her belgede ID'yi de al
        Map<String, dynamic> songData = doc.data() as Map<String, dynamic>;
        songData['id'] = doc.id; // Belge ID'sini ekle
        songsList.add(songData);
      }
    } catch (e) {
      print("Error fetching liked songs: $e");
    }

    return songsList;
  }

  Future<void> deleteSong(String songId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail) // Kullanıcının email'ini doküman ID'si olarak kullan
          .collection('liked_songs')
          .doc(songId) // Şarkının ID'sini kullanarak sil
          .delete();
      setState(() {
        // Şarkıyı silerken listeyi güncelle
        likedSongs = fetchLikedSongs();
      });
    } catch (e) {
      print("Error deleting song: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library", style: TextStyle(color: Colors.white)), // Yazı rengi beyaz
        backgroundColor: Colors.black, // AppBar arka plan rengi
        iconTheme: IconThemeData(color: Colors.white), // Geri butonunun rengi beyaz
      ),
      backgroundColor: Colors.black, // Scaffold arka plan rengi
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: likedSongs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No liked songs found.", style: TextStyle(color: Colors.white)));
          } else {
            List<Map<String, dynamic>> songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final songId = song['id']; // Şarkının ID'si burada
                return ListTile(
                  leading: Image.network(song['albumArt']),
                  title: Text(song['title'], style: TextStyle(color: Colors.white)), // Yazı rengi
                  subtitle: Text(song['artist'], style: TextStyle(color: Colors.grey)), // Alt yazı rengi
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red), // İkon rengi
                    onPressed: () {
                      // Silme onayı istemek
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Delete Song"),
                            content: Text("Are you sure you want to delete this song?", style: TextStyle(color: Colors.black)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  deleteSong(songId);
                                  Navigator.of(context).pop(); // Dialogu kapat
                                },
                                child: Text("Yes", style: TextStyle(color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dialogu kapat
                                },
                                child: Text("No", style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
