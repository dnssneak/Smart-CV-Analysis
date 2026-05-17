import 'package:flutter/material.dart';
import '../models/analysis_model.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<AnalysisModel> _recentAnalyses = [];
  AnalysisModel? _latestAnalysis;

  bool get isLoading => _isLoading;
  List<AnalysisModel> get recentAnalyses => _recentAnalyses;
  AnalysisModel? get latestAnalysis => _latestAnalysis;
  int get totalAnalyses => _recentAnalyses.length;

  DashboardProvider() {
    loadMockData();
  }

  void loadMockData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _recentAnalyses = [
        AnalysisModel(
          id: '1',
          userId: 'user1',
          resumeName: 'Software_Engineer_Resume.pdf',
          atsScore: 82,
          strengths: ['Strong technical skills', 'Clear project descriptions'],
          weaknesses: ['Missing certifications', 'Weak summary'],
          suggestions: ['Add measurable achievements', 'Include keywords'],
          recommendedRoles: ['Flutter Developer', 'Mobile Engineer'],
          missingSkills: ['Docker', 'AWS'],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        AnalysisModel(
          id: '2',
          userId: 'user1',
          resumeName: 'Flutter_Dev_Resume.pdf',
          atsScore: 75,
          strengths: ['Good formatting', 'Relevant experience'],
          weaknesses: ['No leadership examples', 'Missing soft skills'],
          suggestions: ['Add team projects', 'Quantify impact'],
          recommendedRoles: ['AI Engineer', 'Full Stack Developer'],
          missingSkills: ['Python', 'Machine Learning'],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
      _latestAnalysis = _recentAnalyses.first;
      _isLoading = false;
      notifyListeners();
    });
  }
}