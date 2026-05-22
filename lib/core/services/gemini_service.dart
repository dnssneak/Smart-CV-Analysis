import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  GeminiService._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static String get _baseUrl {
    // Set to true to use local Firebase Emulator instead of production URL
    const bool useEmulator = false;

    if (useEmulator && kDebugMode) {
      if (kIsWeb) {
        return 'http://localhost:5001/smart-cv-analysis/us-central1';
      }
      return defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:5001/smart-cv-analysis/us-central1'
          : 'http://localhost:5001/smart-cv-analysis/us-central1';
    }
    return 'https://us-central1-smart-cv-analysis.cloudfunctions.net';
  }

  static Future<Map<String, dynamic>> analyzeResume(String resumeText) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/analyzeResume',
        data: {
          'resumeText': resumeText,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          return jsonDecode(response.data as String) as Map<String, dynamic>;
        }
      }

      throw Exception('Invalid response from server');
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
  "summary": <string brief overview 1-2 sentences>
}

Scoring criteria:
- Formatting and structure (25 points)
- Keyword optimization (25 points)
- Content quality (25 points)
- Skills match (25 points)

Be honest but constructive. Focus on actionable improvements.
''';
  }

  static Future<Map<String, dynamic>> mockAnalyzeResume(
      String resumeText) async {
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
      'missingSkills': ['Docker', 'AWS', 'CI/CD', 'Unit Testing'],
      'recommendedRoles': [
        'Flutter Developer',
        'Mobile Application Developer',
        'Frontend Engineer'
      ],
      'summary':
          'Solid technical foundation with room for improvement in quantifying impact and adding modern DevOps skills.',
    };
  }
}
