import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

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

  // Get download URL for a stored resume
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

  // Upload any generic file
  static Future<String> uploadFile(
    File file,
    String path,
  ) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Delete any file by full path
  static Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}