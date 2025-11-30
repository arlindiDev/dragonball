import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/theme/colors.dart';
import '../../../../../core/ui/widgets/dragonball_loader.dart';
import '../../../../../injection_container.dart';
import '../../bloc/character_detail/character_detail_bloc.dart';
import '../../bloc/character_detail/character_detail_event.dart';
import '../../bloc/character_detail/character_detail_state.dart';
import '../widgets/animated_background.dart';
import '../widgets/character_detail_loaded_view.dart';
import '../widgets/error_view.dart';

class CharacterDetailScreen extends StatelessWidget {
  final int characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CharacterDetailBloc>()
        ..add(LoadCharacterDetail(characterId)),
      child: const _CharacterDetailView(),
    );
  }
}

class _CharacterDetailView extends StatelessWidget {
  const _CharacterDetailView();

  List<Color> _getGradientColors(int characterId) {
    return AppColors.getGradientByIndex(characterId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
      builder: (context, state) {
        final gradientColors = state is CharacterDetailLoaded
            ? _getGradientColors(state.character.id)
            : [const Color(0xFFFF6B00), const Color(0xFFFF8C00)];

        return Scaffold(
          body: Stack(
            children: [
              const AnimatedBackground(),
              
              switch (state) {
                CharacterDetailInitial() => const SizedBox.shrink(),
                CharacterDetailLoading() => const Center(
                    child: DragonBallLoader(size: 100),
                  ),
                CharacterDetailError() => ErrorView(
                    title: 'Error loading character',
                    message: state.message,
                    onRetry: () {
                      final bloc = context.read<CharacterDetailBloc>();
                      if (bloc.state is CharacterDetailError) {
                        final screen = context
                            .findAncestorWidgetOfExactType<CharacterDetailScreen>();
                        if (screen != null) {
                          bloc.add(LoadCharacterDetail(screen.characterId));
                        }
                      }
                    },
                  ),
                CharacterDetailLoaded() => CharacterDetailLoadedView(
                    character: state.character,
                    gradientColors: gradientColors,
                  ),
              },
              
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: gradientColors[0].withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/back.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

