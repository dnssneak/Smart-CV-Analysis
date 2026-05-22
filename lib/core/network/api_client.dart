import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.geminiBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: ApiConstants.defaultHeaders,
    ),
  );

  static Dio get instance => _dio;

  static Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(ApiConstants.timeoutError);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return Exception(ApiConstants.networkError);
      case DioExceptionType.badResponse:
        return Exception(
          'Server error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
        );
      default:
        return Exception(ApiConstants.unknownError);
    }
  }
}