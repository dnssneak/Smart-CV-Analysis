import 'package:flutter/material.dart';
import '../core/services/gemini_service.dart';
import '../firebase/firestore_service.dart';
import '../models/analysis_model.dart';

enum AnalysisState { idle, loading, success, error }

class AnalysisProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  AnalysisState _state = AnalysisState.idle;
  String? _errorMessage;
  AnalysisModel? _currentAnalysis;
  List<AnalysisModel> _analysisHistory = [];
  bool _isLoadingHistory = false;

  AnalysisState get state => _state;
  String? get errorMessage => _errorMessage;
  AnalysisModel? get currentAnalysis => _currentAnalysis;
  List<AnalysisModel> get analysisHistory => _analysisHistory;
  bool get isLoading => _state == AnalysisState.loading;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get hasResult => _currentAnalysis != null;

  // Load history from Firestore
  Future<void> loadHistory(String userId) async {
    try {
      _isLoadingHistory = true;
      notifyListeners();

      _analysisHistory = await _firestoreService.getUserAnalyses(userId);
      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Analyze and save to Firestore
  Future<void> analyzeResume(
    String resumeText, {
    String resumeName = 'Resume',
    required String userId,
  }) async {
    try {
      _state = AnalysisState.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await GeminiService.mockAnalyzeResume(resumeText);
      // final result = await GeminiService.analyzeResume(resumeText);

      _currentAnalysis = AnalysisModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        resumeName: resumeName,
        atsScore: result['atsScore'] ?? 0,
        strengths: List<String>.from(result['strengths'] ?? []),
        weaknesses: List<String>.from(result['weaknesses'] ?? []),
        suggestions: List<String>.from(result['suggestions'] ?? []),
        recommendedRoles: List<String>.from(result['recommendedRoles'] ?? []),
        missingSkills: List<String>.from(result['missingSkills'] ?? []),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestoreService.saveAnalysis(_currentAnalysis!, userId);

      // Refresh history
      await loadHistory(userId);

      _state = AnalysisState.success;
      notifyListeners();
    } catch (e) {
      _state = AnalysisState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete analysis
  Future<void> deleteAnalysis(String userId, String analysisId) async {
    try {
      await _firestoreService.deleteAnalysis(userId, analysisId);
      await loadHistory(userId);
    } catch (e) {
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
