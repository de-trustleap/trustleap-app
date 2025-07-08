import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _claudeUrl = 'https://api.anthropic.com/v1/messages';
  final String _apiKey;

  AIService({required String apiKey}) : _apiKey = apiKey;

  Future<String> generateContent({
    required String systemPrompt,
    required String userPrompt,
    double temperature = 0.7,
    int maxTokens = 8000,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
      'anthropic-version': '2023-06-01',
    };

    final body = jsonEncode({
      'model': 'claude-3-5-sonnet-20241022',
      'max_tokens': maxTokens,
      'temperature': temperature,
      'system': systemPrompt,
      'messages': [
        {'role': 'user', 'content': userPrompt}
      ],
    });

    try {
      final response = await http.post(
        Uri.parse(_claudeUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        final errorData = jsonDecode(response.body);
        throw AIServiceException('Claude API request failed: ${response.statusCode} - ${errorData['error']?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw AIServiceException('Failed to generate content: $e');
    }
  }

  Future<Map<String, dynamic>> generateJSON({
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final content = await generateContent(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      temperature: 0.3, // Lower temperature for more consistent JSON
    );

    try {
      // Extract JSON from response (in case AI adds extra text)
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = content.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonString);
      } else {
        throw AIServiceException('No valid JSON found in response');
      }
    } catch (e) {
      throw AIServiceException('Failed to parse JSON: $e');
    }
  }
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}