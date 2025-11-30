import 'package:dio/dio.dart';
import 'character_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  static const String _charactersEndpoint = '/characters';
  
  final Dio _dio;

  CharacterRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Map<String, dynamic>> getCharacters({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        _charactersEndpoint,
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

  @override
  Future<Map<String, dynamic>> getCharacterById(int id) async {
    try {
      final response = await _dio.get('$_charactersEndpoint/$id');
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerException('Server error ($statusCode). Please try again later.');
          } else if (statusCode == 404) {
            return ServerException('Resource not found.');
          } else if (statusCode == 401 || statusCode == 403) {
            return ServerException('Access denied.');
          } else {
            return ServerException('Request failed with status code $statusCode.');
          }
        }
        return ServerException('Server error. Please try again later.');
      
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network settings.');
      
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      
      case DioExceptionType.badCertificate:
        return NetworkException('Security certificate error.');
      
      case DioExceptionType.unknown:
        if (error.error != null) {
          return NetworkException('Network error: ${error.error}');
        }
        return NetworkException('Something went wrong. Please try again.');
    }
  }
}

