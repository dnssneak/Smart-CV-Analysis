import 'package:flutter/material.dart';
import '../core/services/gemini_service.dart';
import '../models/analysis_model.dart';

enum AnalysisState { idle, loading, success, error }

class AnalysisProvider extends ChangeNotifier {
  AnalysisState _state = AnalysisState.idle;
  String? _errorMessage;
  AnalysisModel? _currentAnalysis;
  List<AnalysisModel> _analysisHistory = [];

  AnalysisState get state => _state;
  String? get errorMessage => _errorMessage;
  AnalysisModel? get currentAnalysis => _currentAnalysis;
  List<AnalysisModel> get analysisHistory => _analysisHistory;

  bool get isLoading => _state == AnalysisState.loading;
  bool get hasResult => _currentAnalysis != null;

  Future<void> analyzeResume(String resumeText, {String resumeName = 'Resume'}) async {
    try {
      _state = AnalysisState.loading;
      _errorMessage = null;
      notifyListeners();

      // Use mock for testing, switch to real API when ready
      final result = await GeminiService.mockAnalyzeResume(resumeText);
      // final result = await GeminiService.analyzeResume(resumeText);

      _currentAnalysis = AnalysisModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        resumeName: resumeName,
        atsScore: result['atsScore'] ?? 0,
        strengths: List<String>.from(result['strengths'] ?? []),
        weaknesses: List<String>.from(result['weaknesses'] ?? []),
        suggestions: List<String>.from(result['suggestions'] ?? []),
        recommendedRoles: List<String>.from(result['recommendedRoles'] ?? []),
        missingSkills: List<String>.from(result['missingSkills'] ?? []),
        createdAt: DateTime.now(),
      );

      _analysisHistory.insert(0, _currentAnalysis!);
      _state = AnalysisState.success;
      notifyListeners();
    } catch (e) {
      _state = AnalysisState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearCurrentAnalysis() {
    _currentAnalysis = null;
    _state = AnalysisState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void setCurrentAnalysis(AnalysisModel analysis) {
    _currentAnalysis = analysis;
    _state = AnalysisState.success;
    notifyListeners();
  }
}