import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_characters.dart';
import 'character_list_event.dart';
import 'character_list_state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final GetCharacters getCharacters;
  static const int _pageLimit = 20;

  CharacterListBloc({required this.getCharacters})
      : super(const CharacterListInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(const CharacterListLoading());

    final result = await getCharacters(
      const GetCharactersParams(page: 1, limit: _pageLimit),
    );

    result.fold(
      (failure) => emit(CharacterListError(failure.message)),
      (result) => emit(CharacterListLoaded(
        characters: result.characters,
        hasMore: result.meta.hasMore,
        currentPage: result.meta.currentPage,
      )),
    );
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharacterListState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is! CharacterListLoaded || 
        currentState.isLoadingMore || 
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getCharacters(
      GetCharactersParams(page: nextPage, limit: _pageLimit),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (result) {
        final updatedCharacters = List.of(currentState.characters)
          ..addAll(result.characters);
        
        emit(CharacterListLoaded(
          characters: updatedCharacters,
          hasMore: result.meta.hasMore,
          currentPage: result.meta.currentPage,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharacterListState> emit,
  ) async {
    final result = await getCharacters(
      const GetCharactersParams(page: 1, limit: _pageLimit),
    );

    result.fold(
      (failure) => emit(CharacterListError(failure.message)),
      (result) => emit(CharacterListLoaded(
        characters: result.characters,
        hasMore: result.meta.hasMore,
        currentPage: result.meta.currentPage,
      )),
    );
  }
}

