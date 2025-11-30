import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/constants/api_constants.dart';
import 'features/characters/data/datasources/character_remote_datasource.dart';
import 'features/characters/data/datasources/character_remote_datasource_impl.dart';
import 'features/characters/data/repositories/character_repository_impl.dart';
import 'features/characters/domain/repositories/character_repository.dart';
import 'features/characters/domain/usecases/get_characters.dart';
import 'features/characters/domain/usecases/get_character_detail.dart';
import 'features/characters/presentation/bloc/character_list/character_list_bloc.dart';
import 'features/characters/presentation/bloc/character_detail/character_detail_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  // Dio HTTP client
  serviceLocator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    return dio;
  });

  // Data sources
  serviceLocator.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetCharacters(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCharacterDetail(serviceLocator()));

  // BLoCs (as factories since they should be created fresh each time)
  serviceLocator.registerFactory(
    () => CharacterListBloc(getCharacters: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CharacterDetailBloc(getCharacterDetail: serviceLocator()),
  );
}
