import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_constants.dart';
import '../../games/services/game_api_service.dart';
import '../models/recommendation_result_model.dart';

class RecommendationService {
  final GameApiService _apiService;

  RecommendationService(this._apiService);

  Future<List<RecommendationResult>> getRecommendations(String prompt) async {
    final geminiKey = ApiConstants.geminiApiKey;
    if (geminiKey == null || geminiKey.isEmpty) {
      throw Exception('Gemini API Key is missing. Please add GEMINI_API_KEY to your .env file.');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$geminiKey',
    );

    const systemInstruction =
        "You are a professional video game recommendation AI. Recommend exactly 5 video games based on the user's prompt.\n\n"
        "Return the output STRICTLY as a valid JSON array of objects, with NO markdown formatting, NO backticks (```json), and NO extra text.\n"
        "Each object must have exactly two fields:\n"
        "1. \"title\": the exact title of the game.\n"
        "2. \"reason\": a brief explanation (1-2 sentences) of why this game is recommended based on the user's prompt in the language they used.\n\n"
        "Example format:\n"
        "[\n"
        "  {\"title\": \"Game Name\", \"reason\": \"Recommendation reason...\"}\n"
        "]";

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {
                'text': '$systemInstruction\n\nUser Prompt: "$prompt"'
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API Error: ${response.statusCode} - ${response.body}');
    }

    final data = json.decode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;

    final cleanedText = _cleanJson(text);
    final List parsed = json.decode(cleanedText);

    final List<RecommendationResult> results = [];
    for (var match in parsed) {
      final String title;
      final String reason;
      try {
        title = match['title'] as String;
        reason = match['reason'] as String;
      } catch (e) {
        print('Error parsing recommendation JSON object: $e');
        continue;
      }

      final games = await _apiService.fetchGames(page: 1, search: title);
      if (games.isNotEmpty) {
        final game = games.first;
        results.add(RecommendationResult(
          gameId: game.id,
          gameName: game.name,
          backgroundImage: game.backgroundImage,
          rating: game.rating,
          metacritic: game.metacritic,
          platforms: game.platforms.map((p) => p.platform.slug).toList(),
          genres: game.genres.map((g) => g.name).toList(),
          reason: reason,
        ));
      }
    }

    return results;
  }

  String _cleanJson(String rawText) {
    var cleaned = rawText.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
      if (cleaned.toLowerCase().startsWith('json')) {
        cleaned = cleaned.substring(4);
      }
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    return cleaned.trim();
  }
}
