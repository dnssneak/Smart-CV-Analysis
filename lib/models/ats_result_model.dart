class AtsResultModel {
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final List<String> missingSkills;
  final List<String> recommendedRoles;
  final String? summary;

  AtsResultModel({
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.missingSkills,
    required this.recommendedRoles,
    this.summary,
  });

  factory AtsResultModel.fromJson(Map<String, dynamic> json) {
    return AtsResultModel(
      atsScore: json['atsScore'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? []),
      recommendedRoles: List<String>.from(json['recommendedRoles'] ?? []),
      summary: json['summary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atsScore': atsScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'missingSkills': missingSkills,
      'recommendedRoles': recommendedRoles,
      'summary': summary,
    };
  }
}