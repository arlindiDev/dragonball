import 'package:flutter/material.dart';
import '../../../../../core/ui/widgets/dragonball_loader.dart';
import '../../../../../routes.dart';
import '../../../domain/entities/character.dart';
import 'character_card.dart';

class CharacterListLoadedView extends StatelessWidget {
  final List<Character> characters;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const CharacterListLoadedView({
    super.key,
    required this.characters,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const Center(
        child: Text('No characters found'),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: 24,
        ),
        itemCount: characters.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: DragonBallLoader(size: 50),
              ),
            );
          }

          final character = characters[index];
          return CharacterCard(
            character: character,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.characterDetail,
                arguments: character.id,
              );
            },
          );
        },
      ),
    );
  }
}

