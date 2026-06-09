import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_constants.dart';
import '../models/game_model.dart';
import '../models/game_detail_model.dart';

class GameApiService {
  Future<List<Game>> fetchGames({
    int page = 1,
    String? search,
    String? genres,
  }) async {
    String urlString =
        '${ApiConstants.baseUrl}/games?key=${ApiConstants.apiKey}&page=$page';

    if (search != null && search.isNotEmpty) {
      urlString += '&search=${Uri.encodeComponent(search)}';
    }

    if (genres != null && genres.isNotEmpty) {
      urlString += '&genres=$genres';
    }

    final url = Uri.parse(urlString);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<GameDetail> fetchGameDetail(int id) async {
    final detailUrl = Uri.parse(
      '${ApiConstants.baseUrl}/games/$id?key=${ApiConstants.apiKey}',
    );
    final screenshotsUrl = Uri.parse(
      '${ApiConstants.baseUrl}/games/$id/screenshots?key=${ApiConstants.apiKey}',
    );

    try {
      // Run detail and screenshot fetches concurrently
      final responses = await Future.wait([
        http.get(detailUrl),
        http.get(screenshotsUrl),
      ]);

      final detailRes = responses[0];
      final screenshotsRes = responses[1];

      if (detailRes.statusCode == 200) {
        final detailData = json.decode(detailRes.body);

        List<String> screenshots = [];
        if (screenshotsRes.statusCode == 200) {
          try {
            final screenshotsData = json.decode(screenshotsRes.body);
            final List results = screenshotsData['results'] ?? [];
            screenshots = results.map((e) => e['image'].toString()).toList();
          } catch (e) {
            // Fallback if parsing fails
          }
        }

        detailData['screenshots_list'] = screenshots;
        return GameDetail.fromJson(detailData);
      } else {
        throw Exception('Failed to load game detail');
      }
    } catch (e) {
      throw Exception('Error loading game detail: $e');
    }
  }
}
