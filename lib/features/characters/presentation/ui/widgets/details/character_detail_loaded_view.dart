import 'package:flutter/material.dart';
import '../../../../domain/entities/character_detail.dart';
import 'affiliation_badge.dart';
import 'character_detail_image.dart';
import 'character_detail_section.dart';
import 'character_stat_card.dart';
import 'origin_planet_section.dart';
import 'power_level_badge.dart';
import 'transformation_list.dart';

class CharacterDetailLoadedView extends StatefulWidget {
  final CharacterDetail character;
  final List<Color> gradientColors;

  const CharacterDetailLoadedView({
    super.key,
    required this.character,
    required this.gradientColors,
  });

  @override
  State<CharacterDetailLoadedView> createState() => _CharacterDetailLoadedViewState();
}

class _CharacterDetailLoadedViewState extends State<CharacterDetailLoadedView>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CharacterDetailImage(
            characterId: widget.character.id,
            imageUrl: widget.character.image,
            gradientColors: widget.gradientColors,
            floatAnimation: _floatAnimation,
            glowAnimation: _glowAnimation,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PowerLevelBadge(
                  ki: widget.character.ki,
                  maxKi: widget.character.maxKi,
                  gradientColors: widget.gradientColors,
                  glowAnimation: _glowAnimation,
                ),
                const SizedBox(height: 16),
                _characterName(context),
                const SizedBox(height: 16),
                _characterStats(context),
                const SizedBox(height: 16),
                _characterDescription(context),
                const SizedBox(height: 16),
                CharacterDetailSection(
                  title: 'Origin Planet',
                  icon: Icons.public,
                  gradientColors: widget.gradientColors,
                  child: OriginPlanetSection(
                    planet: widget.character.planet,
                    gradientColors: widget.gradientColors,
                  ),
                ),
                const SizedBox(height: 16),
                CharacterDetailSection(
                  title: 'Transformations',
                  icon: Icons.auto_awesome,
                  gradientColors: widget.gradientColors,
                  child: TransformationList(
                    transformations: widget.character.transformations,
                    glowAnimation: _glowAnimation,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterName(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.white,
            widget.gradientColors[0],
            widget.gradientColors[1],
          ],
        ).createShader(bounds),
        child: Text(
          widget.character.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: widget.gradientColors[0].withValues(alpha: 0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _characterStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CharacterStatCard(
            icon: Icons.groups,
            label: 'Race',
            value: widget.character.race,
            color: widget.gradientColors[0],
            glowAnimation: _glowAnimation,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CharacterStatCard(
            icon: widget.character.gender.toLowerCase() == 'male' 
                ? Icons.male 
                : Icons.female,
            label: 'Gender',
            value: widget.character.gender,
            color: widget.gradientColors[1],
            glowAnimation: _glowAnimation,
          ),
        ),
      ],
    );
  }

  Widget _characterDescription(BuildContext context) {
    return CharacterDetailSection(
      title: 'Description',
      icon: Icons.info,
      gradientColors: widget.gradientColors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AffiliationBadge(affiliation: widget.character.affiliation),
          _buildDescriptionText(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.gradientColors[0].withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.gradientColors[0].withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        widget.character.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[300],
              height: 1.6,
            ),
      ),
    );
  }
}
