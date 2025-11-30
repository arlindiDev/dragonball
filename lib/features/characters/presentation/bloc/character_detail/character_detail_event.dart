import 'package:equatable/equatable.dart';

sealed class CharacterDetailEvent extends Equatable {
  const CharacterDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadCharacterDetail extends CharacterDetailEvent {
  final int characterId;

  const LoadCharacterDetail(this.characterId);

  @override
  List<Object> get props => [characterId];
}

