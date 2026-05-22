import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  // Get app documents directory
  static Future<String> getAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get temp directory
  static Future<String> getTempDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  // Save file to app directory
  static Future<File> saveFile(String fileName, List<int> bytes) async {
    final appDir = await getAppDirectory();
    final filePath = '$appDir/$fileName';
    return await File(filePath).writeAsBytes(bytes);
  }

  // Delete file
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Check if file exists
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  // Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  // Read file as string
  static Future<String> readFileAsString(String filePath) async {
    final file = File(filePath);
    return await file.readAsString();
  }

  // Read file as bytes
  static Future<List<int>> readFileAsBytes(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes();
  }

  // Get file extension
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  // Check if file is PDF
  static bool isPdf(String fileName) {
    return getFileExtension(fileName) == 'pdf';
  }

  // Check if file is DOCX
  static bool isDocx(String fileName) {
    return getFileExtension(fileName) == 'docx';
  }

  // Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}