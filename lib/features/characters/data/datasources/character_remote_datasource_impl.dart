import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'character_remote_datasource.dart';

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
      debugPrint('Fetched characters - page: $page, limit: $limit');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getCharacterById(int id) async {
    try {
      final response = await _dio.get('$_charactersEndpoint/$id');
      debugPrint('Fetched character by id: $id');
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

