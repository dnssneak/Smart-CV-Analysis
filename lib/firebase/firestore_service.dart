import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analysis_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save analysis to Firestore
  Future<void> saveAnalysis(AnalysisModel analysis, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('analyses')
          .doc(analysis.id)
          .set(analysis.toJson());
    } catch (e) {
      throw Exception('Failed to save analysis: $e');
    }
  }

  // Get all analyses for a user
  Future<List<AnalysisModel>> getUserAnalyses(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('analyses')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return AnalysisModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load analyses: $e');
    }
  }

  // Delete an analysis
  Future<void> deleteAnalysis(String userId, String analysisId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('analyses')
          .doc(analysisId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete analysis: $e');
    }
  }
}
