class AnalysisModel {
  final String id;
  final String userId;
  final String resumeName;
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final List<String> recommendedRoles;
  final List<String> missingSkills;
  final DateTime createdAt;

  AnalysisModel({
    required this.id,
    required this.userId,
    required this.resumeName,
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.recommendedRoles,
    required this.missingSkills,
    required this.createdAt,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      resumeName: json['resumeName'] ?? '',
      atsScore: json['atsScore'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      recommendedRoles: List<String>.from(json['recommendedRoles'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'resumeName': resumeName,
      'atsScore': atsScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'recommendedRoles': recommendedRoles,
      'missingSkills': missingSkills,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}