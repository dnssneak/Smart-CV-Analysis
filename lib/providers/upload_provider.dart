import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/pdf_service.dart';

enum UploadState { idle, picking, extracting, uploading, analyzing, success, error }

class UploadProvider extends ChangeNotifier {
  UploadState _state = UploadState.idle;
  String? _errorMessage;
  File? _selectedFile;
  String _fileName = '';
  String _fileSize = '';
  String _extractedText = '';
  String _manualText = '';

  UploadState get state => _state;
  String? get errorMessage => _errorMessage;
  File? get selectedFile => _selectedFile;
  String get fileName => _fileName;
  String get fileSize => _fileSize;
  String get extractedText => _extractedText;
  String get manualText => _manualText;
  bool get hasFile => _selectedFile != null;
  bool get hasText => _extractedText.isNotEmpty || _manualText.isNotEmpty;

  void setManualText(String text) {
    _manualText = text;
    notifyListeners();
  }

  Future<void> pickFile() async {
    try {
      _state = UploadState.picking;
      _errorMessage = null;
      notifyListeners();

      final result = await PdfService.pickFile();
      
      if (result != null) {
        if (result.path == null) {
          _state = UploadState.error;
          _errorMessage = 'File path is not available on this platform';
          notifyListeners();
          return;
        }

        _selectedFile = File(result.path!);
        _fileName = result.name;
        _fileSize = PdfService.formatFileSize(result.size);
        
        _state = UploadState.extracting;
        notifyListeners();

        final extension = (result.extension ?? '').toLowerCase();
        
        if (extension == 'pdf') {
          _extractedText = await PdfService.extractPdfText(result.path!);
        } else if (extension == 'docx') {
          _extractedText = await PdfService.extractDocxText(result.path!);
        } else {
          _state = UploadState.error;
          _errorMessage = 'Unsupported file format: $extension';
          notifyListeners();
          return;
        }

        _state = UploadState.idle;
      } else {
        _state = UploadState.idle;
      }
      notifyListeners();
    } catch (e) {
      _state = UploadState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearFile() {
    _selectedFile = null;
    _fileName = '';
    _fileSize = '';
    _extractedText = '';
    _errorMessage = null;
    _state = UploadState.idle;
    notifyListeners();
  }

  void reset() {
    _selectedFile = null;
    _fileName = '';
    _fileSize = '';
    _extractedText = '';
    _manualText = '';
    _errorMessage = null;
    _state = UploadState.idle;
    notifyListeners();
  }

  String getResumeText() {
    return _extractedText.isNotEmpty ? _extractedText : _manualText;
  }
}