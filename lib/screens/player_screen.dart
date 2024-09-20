import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotify_klon/screens/liked_songs_manager.dart'; // Import the manager

class PlayerScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String previewUrl;
  final String albumArtUrl;

  PlayerScreen({
    required this.songTitle,
    required this.artistName,
    required this.previewUrl,
    required this.albumArtUrl,
  });

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    // Update the manager with the current song when the screen is initialized
    final manager = LikedSongsManager();
    manager.setCurrentSong(widget.songTitle, widget.artistName, widget.albumArtUrl);
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.previewUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void _rewind() {
    final newPosition = _position - Duration(seconds: 10);
    _seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _fastForward() {
    final newPosition = _position + Duration(seconds: 10);
    _seek(newPosition > _duration ? _duration : newPosition);
  }

  void _likeSong() {
    final manager = LikedSongsManager();
    manager.addSong(widget.songTitle, widget.artistName, widget.albumArtUrl);
    manager.setCurrentSong(widget.songTitle, widget.artistName, widget.albumArtUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Song added to your library')),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.songTitle, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 150,
              backgroundImage: NetworkImage(widget.albumArtUrl),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.songTitle,
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.artistName,
            style: TextStyle(color: Colors.grey[300], fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white, size: 36),
                onPressed: _rewind,
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 100,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white, size: 36),
                onPressed: _fastForward,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _likeSong,
            child: Text('Like', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
