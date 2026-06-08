import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
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
    print('Error: GEMINI_API_KEY not found.');
    return;
  }

  final versions = ['v1', 'v1beta'];
  for (var version in versions) {
    print('=== LISTING MODELS FOR VERSION $version ===');
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/$version/models?key=$geminiKey',
    );

    try {
      final response = await http.get(url);
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List models = data['models'] ?? [];
        for (var model in models) {
          print('- Name: ${model['name']}');
          print('  Supported Methods: ${model['supportedGenerationMethods']}');
        }
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    print('');
  }
}
