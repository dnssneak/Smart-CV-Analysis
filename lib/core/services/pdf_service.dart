import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_to_text/docx_to_text.dart';

class PdfService {
  PdfService._();

  static Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      allowMultiple: false,
      withData: kIsWeb,
    );
    return result?.files.first;
  }

  static Future<String> extractPdfText(dynamic fileData) async {
    try {
      Uint8List bytes;

      if (kIsWeb) {
        // Web: fileData is Uint8List? (nullable) from file_picker
        if (fileData == null) {
          throw Exception('File bytes are null');
        }
        bytes = fileData as Uint8List;
      } else {
        // Mobile: fileData is file path string
        final file = File(fileData as String);
        bytes = await file.readAsBytes();
      }

      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      document.dispose();

      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract PDF text: $e');
    }
  }

  static Future<String> extractDocxText(dynamic fileData) async {
    try {
      Uint8List bytes;

      if (kIsWeb) {
        // Web: fileData is Uint8List? (nullable)
        if (fileData == null) {
          throw Exception('File bytes are null');
        }
        bytes = fileData as Uint8List;
      } else {
        // Mobile: fileData is file path string
        final file = File(fileData as String);
        bytes = await file.readAsBytes();
      }

      final text = docxToText(bytes, handleNumbering: true);
      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract DOCX text: $e');
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}