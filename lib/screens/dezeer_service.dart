import 'package:http/http.dart' as http;
import 'dart:convert';

class DeezerService {
  static Future<List<Map<String, dynamic>>> fetchSongs(String query) async {
    final url = Uri.parse('https://api.deezer.com/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Şarkılar yüklenemedi');
    }
  }
}
