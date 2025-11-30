import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character_detail.dart';
import '../repositories/character_repository.dart';

class GetCharacterDetail implements UseCase<CharacterDetail, GetCharacterDetailParams> {
  final CharacterRepository repository;

  GetCharacterDetail(this.repository);

  @override
  Future<Result<Failure, CharacterDetail>> call(GetCharacterDetailParams params) {
    return repository.getCharacterById(params.id);
  }
}

class GetCharacterDetailParams extends Equatable {
  final int id;

  const GetCharacterDetailParams({required this.id});

  @override
  List<Object> get props => [id];
}

