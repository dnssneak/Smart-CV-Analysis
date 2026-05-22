class ApiConstants {
  ApiConstants._();

  // Gemini API
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'models/gemini-2.0-flash';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY'; // Replace with your actual key

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String analysesCollection = 'analyses';

  // API Endpoints
  static String geminiGenerateContentEndpoint(String apiKey) =>
      '$geminiBaseUrl/$geminiModel:generateContent?key=$apiKey';

  // Request Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Error Messages
  static const String networkError = 'Network connection failed. Please check your internet.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String invalidResponseError = 'Invalid response from server.';
}