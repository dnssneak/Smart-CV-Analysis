class ApiConstants {
  ApiConstants._();

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String analysesCollection = 'analyses';

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