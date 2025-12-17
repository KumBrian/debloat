// features/nutrition/data/datasources/ai_remote_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiRemoteService {
  late final GenerativeModel _model;

  // Ideally, store this in an environment variable or --dart-define

  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;

  AiRemoteService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<Map<String, dynamic>> generateGroceryList(
    String userPreferences,
  ) async {
    final prompt =
        '''
      You are a strict nutritionist for an anti-inflammatory, de-bloating diet.
      RULES:
      1. High Potassium (Spinach, Banana, Avocado).
      2. LOW Sodium (No processed meats, no canned soups).
      3. NO Alcohol.
      4. User preferences: $userPreferences
      
      OUTPUT:
      Return a JSON object with this exact structure:
      {
        "items": [
          {"name": "Spinach", "category": "Produce"},
          {"name": "Salmon", "category": "Protein"}
        ],
        "banned_avoided": ["Soy Sauce", "Beer"]
      }
      Do not include markdown formatting. Just raw JSON.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception("AI returned empty response");
      }

      // Sanitize JSON just in case the model adds backticks
      final cleanJson = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed to generate grocery list: $e");
    }
  }
}
