import 'dart:io';
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
    );
    return result?.files.first;
  }

  static Future<String> extractPdfText(String filePath) async {
    try {
      // Read file bytes
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      
      // Load PDF document from bytes
      final document = PdfDocument(inputBytes: bytes);
      
      // Create text extractor and extract all text
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      
      // Dispose document
      document.dispose();
      
      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract PDF text: $e');
    }
  }

  static Future<String> extractDocxText(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
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