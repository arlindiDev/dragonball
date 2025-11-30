import 'package:get_it/get_it.dart';
import 'features/characters/data/datasources/character_remote_datasource.dart';
import 'features/characters/data/datasources/character_remote_datasource_impl.dart';
import 'features/characters/data/repositories/character_repository_impl.dart';
import 'features/characters/domain/repositories/character_repository.dart';
import 'features/characters/domain/usecases/get_characters.dart';
import 'features/characters/domain/usecases/get_character_detail.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Data sources
  serviceLocator.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(),
  );

  // Repository
  serviceLocator.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetCharacters(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCharacterDetail(serviceLocator()));
}
