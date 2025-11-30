import 'package:equatable/equatable.dart';

sealed class CharacterListEvent extends Equatable {
  const CharacterListEvent();

  @override
  List<Object> get props => [];
}

class LoadCharacters extends CharacterListEvent {
  const LoadCharacters();
}

class LoadMoreCharacters extends CharacterListEvent {
  const LoadMoreCharacters();
}

class RefreshCharacters extends CharacterListEvent {
  const RefreshCharacters();
}

