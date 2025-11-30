import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/character_detail.dart';
import '../../domain/entities/character_list_result.dart';
import '../../domain/entities/pagination_meta.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';
import '../models/character_detail_model.dart';
import '../models/pagination_meta_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Failure, CharacterListResult>> getCharacters({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDataSource.getCharacters(
        page: page,
        limit: limit,
      );
      
      final items = response['items'];
      if (items == null || items is! List) {
        final defaultMeta = PaginationMeta(
          totalItems: 0,
          totalPages: 1,
          currentPage: 1,
          itemCount: 0,
        );
        return Result.success(CharacterListResult(
          characters: const <Character>[],
          meta: defaultMeta,
        ));
      }
      
      final characterModels = items
          .where((json) => json != null)
          .map((json) => CharacterModel.fromJson(json))
          .toList();
      
      // Convert models to entities
      final characters = characterModels.map((model) => model.toEntity()).toList();
      
      final metaJson = response['meta'] as Map<String, dynamic>?;
      final PaginationMeta meta;
      
      if (metaJson != null) {
        meta = PaginationMetaModel.fromJson(metaJson).toEntity();
      } else {
        meta = PaginationMeta(
          totalItems: characters.length,
          totalPages: 1,
          currentPage: page,
          itemCount: characters.length,
        );
      }
      
      return Result.success(CharacterListResult(
        characters: characters,
        meta: meta,
      ));
    } on ServerException catch (e) {
      return Result.error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, CharacterDetail>> getCharacterById(int id) async {
    try {
      final response = await remoteDataSource.getCharacterById(id);
      final characterDetailModel = CharacterDetailModel.fromJson(response);
      
      return Result.success(characterDetailModel.toEntity());
    } on ServerException catch (e) {
      return Result.error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }
}
