import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/character_detail.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';
import '../models/character_detail_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Failure, List<Character>>> getCharacters({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDataSource.getCharacters(
        page: page,
        limit: limit,
      );
      
      final characters = (response['items'] as List)
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();
      
      return Result.success(characters);
    } on Exception catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, CharacterDetail>> getCharacterById(int id) async {
    try {
      final response = await remoteDataSource.getCharacterById(id);
      final characterDetail = CharacterDetailModel.fromJson(response).toEntity();
      
      return Result.success(characterDetail);
    } on Exception catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }
}

