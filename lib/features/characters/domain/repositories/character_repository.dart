import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/character_detail.dart';
import '../entities/character_list_result.dart';

abstract class CharacterRepository {
  Future<Result<Failure, CharacterListResult>> getCharacters({
    required int page,
    required int limit,
  });

  Future<Result<Failure, CharacterDetail>> getCharacterById(int id);
}

