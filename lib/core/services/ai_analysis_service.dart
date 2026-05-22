import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AiAnalysisService {
  AiAnalysisService._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static String get _baseUrl {
    // Automatically use local Firebase Emulator in debug mode
    const bool useEmulator = kDebugMode;
    
    // Set this to true if you are testing on a physical Android device connected via USB.
    // If true, you must run 'adb reverse tcp:5001 tcp:5001' in your terminal.
    const bool usePhysicalDevice = true;

    if (useEmulator && kDebugMode) {
      if (kIsWeb) {
        return 'http://127.0.0.1:5001/smart-cv-analysis/us-central1';
      }
      if (defaultTargetPlatform == TargetPlatform.android) {
        return usePhysicalDevice
            ? 'http://192.168.100.168:5001/smart-cv-analysis/us-central1'
            : 'http://10.0.2.2:5001/smart-cv-analysis/us-central1';
      }
      return 'http://192.168.100.168:5001/smart-cv-analysis/us-central1';
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
