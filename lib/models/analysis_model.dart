import 'package:flutter/material.dart';

class AnalysisModel {
  final String id;
  final String userId;
  final String resumeName;
  final String targetJobTitle;
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final List<String> recommendedRoles;
  final List<String> missingSkills;
  final String? summary;
  final DateTime createdAt;

  AnalysisModel({
    required this.id,
    required this.userId,
    required this.resumeName,
    required this.targetJobTitle,
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.recommendedRoles,
    required this.missingSkills,
    this.summary,
    required this.createdAt,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      resumeName: json['resumeName'] ?? '',
      targetJobTitle: json['targetJobTitle'] ?? 'General',
      atsScore: json['atsScore'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      recommendedRoles: List<String>.from(json['recommendedRoles'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? []),
      summary: json['summary'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'resumeName': resumeName,
      'targetJobTitle': targetJobTitle,
      'atsScore': atsScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'recommendedRoles': recommendedRoles,
      'missingSkills': missingSkills,
      'summary': summary,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
