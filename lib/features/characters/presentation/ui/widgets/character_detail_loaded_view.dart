import 'package:flutter/material.dart';
import '../../../../../core/ui/theme/colors.dart';
import '../../../domain/entities/character_detail.dart';
import '../painters/energy_rings_painter.dart';

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
          _characterImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _powerLevelBadge(context),
                const SizedBox(height: 16),
                _characterName(context),
                const SizedBox(height: 16),
                _characterStats(context),
                const SizedBox(height: 16),
                _characterDescription(context),
                const SizedBox(height: 16),
                _originPlanet(context),
                const SizedBox(height: 16),
                _transformations(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _powerLevelBadge(BuildContext context) {
    final hasKi = widget.character.ki != '0';
    final kiValue = hasKi ? widget.character.ki : 'UNKNOWN';
    
    return Center(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradientColors,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: widget.gradientColors[0].withValues(alpha: _glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: widget.gradientColors[1].withValues(alpha: _glowAnimation.value * 0.7),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 24,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KI: $kiValue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    if (widget.character.maxKi != '0')
                      Text(
                        'MAX: ${widget.character.maxKi}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnergyRings() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: EnergyRingsPainter(
              _glowAnimation.value,
              widget.gradientColors,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingCharacterImage() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0]
                        .withValues(alpha: _glowAnimation.value * 0.8),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                  BoxShadow(
                    color: widget.gradientColors[1]
                        .withValues(alpha: _glowAnimation.value * 0.6),
                    blurRadius: 40,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: Image.network(
                widget.character.image,
                height: 320,
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
          );
        },
      ),
    );
  }

  Widget _characterImage(BuildContext context) {
    return Hero(
      tag: 'character_${widget.character.id}',
      child: Container(
        height: 440,
        padding: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              widget.gradientColors[0].withValues(alpha: 0.3),
              widget.gradientColors[1].withValues(alpha: 0.2),
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildEnergyRings(),
            _buildFloatingCharacterImage(),
          ],
        ),
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
          child: _statCard(
            context,
            icon: Icons.groups,
            label: 'Race',
            value: widget.character.race,
            color: widget.gradientColors[0],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            context,
            icon: widget.character.gender.toLowerCase() == 'male' 
                ? Icons.male 
                : Icons.female,
            label: 'Gender',
            value: widget.character.gender,
            color: widget.gradientColors[1],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[900]!,
                color.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: _glowAnimation.value * 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAffiliationBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getAffiliationColors(widget.character.affiliation),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getAffiliationColors(widget.character.affiliation)[0]
                  .withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getAffiliationIcon(widget.character.affiliation),
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.character.affiliation.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
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

  Widget _characterDescription(BuildContext context) {
    return _buildSection(
      context,
      title: 'Description',
      icon: Icons.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAffiliationBadge(),
          _buildDescriptionText(context),
        ],
      ),
    );
  }

  List<Color> _getAffiliationColors(String affiliation) {
    final lowerAffiliation = affiliation.toLowerCase();
    if (lowerAffiliation.contains('z fighter') || lowerAffiliation.contains('z-fighter')) {
      return [const Color(0xFF0066CC), const Color(0xFF0099FF)];
    } else if (lowerAffiliation.contains('army') || lowerAffiliation.contains('frieza')) {
      return [const Color(0xFF9900CC), const Color(0xFFCC00FF)];
    } else if (lowerAffiliation.contains('freelancer')) {
      return [const Color(0xFF00CC66), const Color(0xFF00FF99)];
    } else if (lowerAffiliation.contains('red ribbon')) {
      return [const Color(0xFFCC0000), const Color(0xFFFF3333)];
    } else {
      return [const Color(0xFF666666), const Color(0xFF888888)];
    }
  }

  IconData _getAffiliationIcon(String affiliation) {
    final lowerAffiliation = affiliation.toLowerCase();
    if (lowerAffiliation.contains('z fighter') || lowerAffiliation.contains('z-fighter')) {
      return Icons.shield;
    } else if (lowerAffiliation.contains('army') || lowerAffiliation.contains('frieza')) {
      return Icons.rocket;
    } else if (lowerAffiliation.contains('freelancer')) {
      return Icons.person;
    } else if (lowerAffiliation.contains('red ribbon')) {
      return Icons.military_tech;
    } else {
      return Icons.help_outline;
    }
  }

  Widget _originPlanet(BuildContext context) {
    return _buildSection(
      context,
      title: 'Origin Planet',
      icon: Icons.public,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              widget.gradientColors[0].withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.gradientColors[0].withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0].withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.public,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.character.planet?.name ?? 'Unknown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTransformationsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[700]!,
          width: 1,
        ),
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
    );
  }

  Widget _buildTransformationCard(BuildContext context, int index, dynamic transformation) {
    final transformationColor = _getTransformationColor(index);
    
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(
            bottom: index < widget.character.transformations.length - 1
                ? 12.0
                : 0,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[900]!,
                transformationColor.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: transformationColor.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: transformationColor
                    .withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: transformationColor.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: transformationColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 24,
                  color: transformationColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  transformation.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
              ),
              Icon(
                Icons.star,
                color: transformationColor,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransformationsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.character.transformations
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final transformation = entry.value;
        return _buildTransformationCard(context, index, transformation);
      }).toList(),
    );
  }

  Widget _transformations(BuildContext context) {
    return _buildSection(
      context,
      title: 'Transformations',
      icon: Icons.auto_awesome,
      child: widget.character.transformations.isEmpty
          ? _buildEmptyTransformationsState(context)
          : _buildTransformationsList(context),
    );
  }

  Color _getTransformationColor(int index) {
    return AppColors.getTransformationColor(index);
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.white, widget.gradientColors[0]],
              ).createShader(bounds),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

