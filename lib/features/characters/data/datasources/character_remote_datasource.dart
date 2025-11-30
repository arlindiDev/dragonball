abstract class CharacterRemoteDataSource {
  Future<Map<String, dynamic>> getCharacters({
    required int page,
    required int limit,
  });

  Future<Map<String, dynamic>> getCharacterById(int id);
}

