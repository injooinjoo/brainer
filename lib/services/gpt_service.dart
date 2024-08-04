import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class GPTService {
  final String? _apiKey = FlutterConfig.get('OPENAI_API_KEY');

  Future<Map<String, dynamic>> generateQuestion(String prompt) async {
    if (_apiKey == null) {
      throw Exception('OpenAI API key is not set');
    }

    final url = Uri.parse('https://api.openai.com/v1/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt4o-mini', // GPT 모델 명시
        'prompt': prompt,
        'max_tokens': 150, // 생성할 텍스트의 최대 길이
        'n': 1, // 하나의 답변 생성
        'stop': '\n', // 텍스트 끝을 알리는 구분자
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to generate question');
    }
  }
}
