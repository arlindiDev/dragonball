import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacters implements UseCase<List<Character>, GetCharactersParams> {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  @override
  Future<Result<Failure, List<Character>>> call(GetCharactersParams params) {
    return repository.getCharacters(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCharactersParams extends Equatable {
  final int page;
  final int limit;

  const GetCharactersParams({
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [page, limit];
}

