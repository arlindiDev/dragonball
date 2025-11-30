import 'package:flutter/material.dart';
import '../api/dragon_ball_api.dart';
import '../models/character_detail.dart';

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final DragonBallApi _api = DragonBallApi();
  
  CharacterDetail? _character;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCharacterDetail();
  }

  Future<void> _loadCharacterDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.fetchCharacterById(widget.characterId);
      final character = CharacterDetail.fromJson(response);

      setState(() {
        _character = character;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character?.name ?? 'Character Detail'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
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
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadCharacterDetail,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_character == null) {
      return const Center(
        child: Text('Character not found'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _characterImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _characterName(),
                const SizedBox(height: 16),
                _characterDescription(),
                const SizedBox(height: 16),
                _originPlanet(),
                const SizedBox(height: 16),
                _transformations(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterImage() {
    return Hero(
      tag: 'character_${_character!.id}',
      child: Image.network(
        _character!.image,
        height: 300,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 300,
            color: Colors.grey[300],
            child: const Icon(Icons.person, size: 100),
          );
        },
      ),
    );
  }

  Widget _characterName() {
    return Text(
      _character!.name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _characterDescription() {
    return _buildSection(
      context,
      title: 'Description',
      child: Text(
        _character!.description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _originPlanet() {
    return _buildSection(
      context,
      title: 'Origin Planet',
      child: Row(
        children: [
          Icon(
            Icons.public,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            _character!.planetName ?? 'Unknown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _transformations() {
    return _buildSection(
      context,
      title: 'Transformations',
      child: _character!.transformations.isEmpty
          ? Text(
              'No transformations',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _character!.transformations.map((transformation) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          transformation,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

