import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

sealed class CharacterListState extends Equatable {
  const CharacterListState();

  @override
  List<Object> get props => [];
}

class CharacterListInitial extends CharacterListState {
  const CharacterListInitial();
}

class CharacterListLoading extends CharacterListState {
  const CharacterListLoading();
}

class CharacterListLoaded extends CharacterListState {
  final List<Character> characters;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  const CharacterListLoaded({
    required this.characters,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [characters, hasMore, currentPage, isLoadingMore];

  CharacterListLoaded copyWith({
    List<Character>? characters,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return CharacterListLoaded(
      characters: characters ?? this.characters,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CharacterListError extends CharacterListState {
  final String message;

  const CharacterListError(this.message);

  @override
  List<Object> get props => [message];
}

