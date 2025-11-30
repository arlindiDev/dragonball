import 'package:dio/dio.dart';

class DragonBallApi {
  static const String baseUrl = 'https://dragonball-api.com/api';
  
  final Dio _dio;

  DragonBallApi({Dio? dio}) 
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<Map<String, dynamic>> fetchCharacters({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '/characters',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> fetchCharacterById(int id) async {
    try {
      final response = await _dio.get('/characters/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${error.response?.statusCode}');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong: ${error.message}');
    }
  }
}
