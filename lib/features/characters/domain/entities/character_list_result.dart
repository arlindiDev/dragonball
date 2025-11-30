import 'package:equatable/equatable.dart';
import 'character.dart';
import 'pagination_meta.dart';

class CharacterListResult extends Equatable {
  final List<Character> characters;
  final PaginationMeta meta;

  const CharacterListResult({
    required this.characters,
    required this.meta,
  });

  @override
  List<Object?> get props => [characters, meta];
}

