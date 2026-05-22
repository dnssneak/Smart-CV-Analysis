class ResumeModel {
  final String id;
  final String userId;
  final String fileName;
  final String? fileUrl;
  final String? localPath;
  final String? extractedText;
  final int fileSize;
  final String fileType;
  final DateTime uploadedAt;

  ResumeModel({
    required this.id,
    required this.userId,
    required this.fileName,
    this.fileUrl,
    this.localPath,
    this.extractedText,
    required this.fileSize,
    required this.fileType,
    required this.uploadedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'],
      localPath: json['localPath'],
      extractedText: json['extractedText'],
      fileSize: json['fileSize'] ?? 0,
      fileType: json['fileType'] ?? '',
      uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'localPath': localPath,
      'extractedText': extractedText,
      'fileSize': fileSize,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isPdf => fileType.toLowerCase() == 'pdf';
  bool get isDocx => fileType.toLowerCase() == 'docx';
  bool get hasText => extractedText != null && extractedText!.isNotEmpty;
}