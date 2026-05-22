import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._();

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload resume file to Firebase Storage
  static Future<String> uploadResumeFile(
    File file,
    String userId,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('users/$userId/resumes/$fileName');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload resume: $e');
    }
  }

  // Delete resume file from Firebase Storage
  static Future<void> deleteResumeFile(
    String userId,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('users/$userId/resumes/$fileName');
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete resume: $e');
    }
  }

  // Get download URL for a resume
  static Future<String> getResumeDownloadUrl(
    String userId,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('users/$userId/resumes/$fileName');
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}