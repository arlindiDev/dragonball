import 'package:flutter/material.dart';
import 'features/characters/presentation/screens/character_list_screen.dart';
import 'features/characters/presentation/screens/character_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String characterDetail = '/character-detail';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const CharacterListScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == characterDetail) {
      final characterId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => CharacterDetailScreen(characterId: characterId),
      );
    }
    return null;
  }
}

