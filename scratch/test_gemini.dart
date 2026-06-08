import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  // Read GEMINI_API_KEY from .env
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('Error: .env file not found.');
    return;
  }

  String? geminiKey;
  final lines = envFile.readAsLinesSync();
  for (var line in lines) {
    if (line.startsWith('GEMINI_API_KEY=')) {
      geminiKey = line.split('GEMINI_API_KEY=')[1].trim();
    }
  }

  if (geminiKey == null || geminiKey.isEmpty) {
    print('Error: GEMINI_API_KEY not found in .env.');
    return;
  }

  print('Using Gemini Key: ${geminiKey.substring(0, 5)}...');

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$geminiKey',
  );

  const systemInstruction =
      "You are a professional video game recommendation AI. Recommend exactly 3 video games based on the user's prompt.\n\n"
      "Return the output STRICTLY as a valid JSON array of objects, with NO markdown formatting, NO backticks (```json), and NO extra text.\n"
      "Each object must have exactly two fields:\n"
      "1. \"title\": the exact title of the game.\n"
      "2. \"reason\": a brief explanation (1-2 sentences) of why this game is recommended.\n\n"
      "Example format:\n"
      "[\n"
      "  {\"title\": \"Game Name\", \"reason\": \"Recommendation reason...\"}\n"
      "]";

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {
                'text': '$systemInstruction\n\nUser Prompt: "elden ring"'
              }
            ]
          }
        ]
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
      print('Extracted Text:');
      print(text);

      try {
        final cleanedText = cleanJson(text);
        print('Cleaned Text:');
        print(cleanedText);
        final List parsed = json.decode(cleanedText);
        print('Successfully parsed JSON list: $parsed');
      } catch (e) {
        print('JSON Parsing Error: $e');
      }
    }
  } catch (e) {
    print('Exception: $e');
  }
}

String cleanJson(String rawText) {
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
