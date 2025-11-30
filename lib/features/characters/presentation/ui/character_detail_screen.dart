import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/character_detail.dart';
import '../bloc/character_detail/character_detail_bloc.dart';
import '../bloc/character_detail/character_detail_event.dart';
import '../bloc/character_detail/character_detail_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset(
                'assets/images/back.png',
                width: 32,
                height: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              state is CharacterDetailLoaded
                  ? state.character.name
                  : 'Character Detail',
            ),
          ),
          body: switch (state) {
            CharacterDetailInitial() => const SizedBox.shrink(),
            CharacterDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            CharacterDetailError() => _ErrorView(
                message: state.message,
                onRetry: () {
                  final bloc = context.read<CharacterDetailBloc>();
                  // Get the character ID from the last event
                  if (bloc.state is CharacterDetailError) {
                    // Re-trigger load - we need to extract ID from the screen
                    final screen = context
                        .findAncestorWidgetOfExactType<CharacterDetailScreen>();
                    if (screen != null) {
                      bloc.add(LoadCharacterDetail(screen.characterId));
                    }
                  }
                },
              ),
            CharacterDetailLoaded() => _LoadedView(character: state.character),
          },
        );
      },
    );
  }
}

class _LoadedView extends StatefulWidget {
  final CharacterDetail character;

  const _LoadedView({required this.character});

  @override
  State<_LoadedView> createState() => _LoadedViewState();
}

class _LoadedViewState extends State<_LoadedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _characterImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _characterName(context),
                const SizedBox(height: 16),
                _characterDescription(context),
                const SizedBox(height: 16),
                _originPlanet(context),
                const SizedBox(height: 16),
                _transformations(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterImage(BuildContext context) {
    return Hero(
      tag: 'character_${widget.character.id}',
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: child,
              );
            },
            child: Image.network(
              widget.character.image,
              height: 280,
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[700],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _characterName(BuildContext context) {
    return Text(
      widget.character.name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );
  }

  Widget _characterDescription(BuildContext context) {
    return _buildSection(
      context,
      title: 'Description',
      child: Text(
        widget.character.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[300],
            ),
      ),
    );
  }

  Widget _originPlanet(BuildContext context) {
    return _buildSection(
      context,
      title: 'Origin Planet',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.public,
              color: Colors.grey[400],
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              widget.character.planet?.name ?? 'Unknown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transformations(BuildContext context) {
    return _buildSection(
      context,
      title: 'Transformations',
      child: widget.character.transformations.isEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'No transformations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.character.transformations
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final transformation = entry.value;
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index < widget.character.transformations.length - 1
                        ? 8.0
                        : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[700]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          transformation.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading character',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

