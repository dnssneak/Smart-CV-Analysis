import 'dart:convert';
import 'package:dio/dio.dart';

class GeminiService {
  GeminiService._();

  static const String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with your key
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String _model = 'models/gemini-2.0-flash';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<Map<String, dynamic>> analyzeResume(String resumeText) async {
    try {
      final prompt = _buildPrompt(resumeText);
      
      final response = await _dio.post(
        '$_model:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'maxOutputTokens': 2048,
            'responseMimeType': 'application/json',
          }
        },
      );

      if (response.statusCode == 200) {
        final candidates = response.data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content']['parts'][0]['text'];
          return jsonDecode(content);
        }
      }

      throw Exception('Invalid response from Gemini API');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Analysis failed: $e');
    }
  }

  static String _buildPrompt(String resumeText) {
    return '''
Analyze this resume and provide structured feedback.

Resume Content:
$resumeText

Return ONLY a JSON object with this exact structure:
{
  "atsScore": <number 0-100>,
  "strengths": [<string array>],
  "weaknesses": [<string array>],
  "suggestions": [<string array>],
  "missingSkills": [<string array>],
  "recommendedRoles": [<string array>],
  "summary": <string brief overview>
}

Scoring criteria:
- Formatting and structure (25 points)
- Keyword optimization (25 points)
- Content quality (25 points)
- Skills match (25 points)

Be honest but constructive. Focus on actionable improvements.
''';
  }

  static Future<Map<String, dynamic>> mockAnalyzeResume(String resumeText) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'atsScore': 78,
      'strengths': [
        'Clear technical skills section',
        'Good project descriptions',
        'Relevant experience listed'
      ],
      'weaknesses': [
        'Missing measurable achievements',
        'No certifications listed',
        'Weak professional summary'
      ],
      'suggestions': [
        'Add quantifiable results to projects',
        'Include relevant certifications',
        'Strengthen summary with key achievements',
        'Add more action verbs'
      ],
      'missingSkills': [
        'Docker',
        'AWS',
        'CI/CD',
        'Unit Testing'
      ],
      'recommendedRoles': [
        'Flutter Developer',
        'Mobile Application Developer',
        'Frontend Engineer'
      ],
      'summary': 'Solid technical foundation with room for improvement in quantifying impact and adding modern DevOps skills.'
    };
  }
}