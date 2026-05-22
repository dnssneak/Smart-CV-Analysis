import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/services/pdf_service.dart';

enum UploadState { idle, picking, extracting, uploading, analyzing, success, error }

class UploadProvider extends ChangeNotifier {
  UploadState _state = UploadState.idle;
  String? _errorMessage;
  File? _selectedFile; // Mobile only
  Uint8List? _fileBytes; // Web only
  String _fileName = '';
  String _fileSize = '';
  String _extractedText = '';
  String _manualText = '';

  UploadState get state => _state;
  String? get errorMessage => _errorMessage;
  File? get selectedFile => _selectedFile;
  Uint8List? get fileBytes => _fileBytes;
  String get fileName => _fileName;
  String get fileSize => _fileSize;
  String get extractedText => _extractedText;
  String get manualText => _manualText;
  bool get hasFile => _selectedFile != null || _fileBytes != null;
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
        _fileName = result.name;
        _fileSize = PdfService.formatFileSize(result.size);
        
        _state = UploadState.extracting;
        notifyListeners();

        final extension = (result.extension ?? '').toLowerCase();
        
        if (kIsWeb) {
          // Web: Use bytes directly
          if (result.bytes == null) {
            _state = UploadState.error;
            _errorMessage = 'File bytes not available';
            notifyListeners();
            return;
          }
          _fileBytes = result.bytes;
          
          if (extension == 'pdf') {
            _extractedText = await PdfService.extractPdfText(result.bytes);
          } else if (extension == 'docx') {
            _extractedText = await PdfService.extractDocxText(result.bytes);
          } else {
            _state = UploadState.error;
            _errorMessage = 'Unsupported file format: $extension';
            notifyListeners();
            return;
          }
        } else {
          // Mobile: Use file path
          if (result.path == null) {
            _state = UploadState.error;
            _errorMessage = 'File path not available';
            notifyListeners();
            return;
          }
          _selectedFile = File(result.path!);
          
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
    _fileBytes = null;
    _fileName = '';
    _fileSize = '';
    _extractedText = '';
    _errorMessage = null;
    _state = UploadState.idle;
    notifyListeners();
  }

  void reset() {
    _selectedFile = null;
    _fileBytes = null;
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