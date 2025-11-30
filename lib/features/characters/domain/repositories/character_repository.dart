import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/character.dart';
import '../entities/character_detail.dart';

abstract class CharacterRepository {
  Future<Result<Failure, List<Character>>> getCharacters({
    required int page,
    required int limit,
  });

  Future<Result<Failure, CharacterDetail>> getCharacterById(int id);
}

