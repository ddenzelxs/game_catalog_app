import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_constants.dart';
import '../models/game_model.dart';

class GameApiService {
  Future<List<Game>> fetchGames({int page = 1}) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/games?key=${ApiConstants.apiKey}&page=$page',
    );

    final response = await http.get(url);  

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }
}
