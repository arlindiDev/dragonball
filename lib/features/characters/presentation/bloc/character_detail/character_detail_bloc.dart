import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_character_detail.dart';
import 'character_detail_event.dart';
import 'character_detail_state.dart';

class CharacterDetailBloc
    extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  final GetCharacterDetail getCharacterDetail;

  CharacterDetailBloc({required this.getCharacterDetail})
      : super(const CharacterDetailInitial()) {
    on<LoadCharacterDetail>(_onLoadCharacterDetail);
  }

  Future<void> _onLoadCharacterDetail(
    LoadCharacterDetail event,
    Emitter<CharacterDetailState> emit,
  ) async {
    emit(const CharacterDetailLoading());

    final result = await getCharacterDetail(
      GetCharacterDetailParams(id: event.characterId),
    );

    result.fold(
      (failure) => emit(CharacterDetailError(failure.message)),
      (character) => emit(CharacterDetailLoaded(character)),
    );
  }
}

