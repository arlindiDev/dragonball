import 'package:flutter/material.dart';
import '../../painters/energy_rings_painter.dart';

class CharacterDetailImage extends StatelessWidget {
  final int characterId;
  final String imageUrl;
  final List<Color> gradientColors;
  final Animation<double> floatAnimation;
  final Animation<double> glowAnimation;

  const CharacterDetailImage({
    super.key,
    required this.characterId,
    required this.imageUrl,
    required this.gradientColors,
    required this.floatAnimation,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'character_$characterId',
      child: Container(
        height: 440,
        padding: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              gradientColors[0].withValues(alpha: 0.3),
              gradientColors[1].withValues(alpha: 0.2),
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

  Widget _buildEnergyRings() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: EnergyRingsPainter(
              glowAnimation.value,
              gradientColors,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingCharacterImage() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([floatAnimation, glowAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, floatAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0]
                        .withValues(alpha: glowAnimation.value * 0.8),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                  BoxShadow(
                    color: gradientColors[1]
                        .withValues(alpha: glowAnimation.value * 0.6),
                    blurRadius: 40,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: Image.network(
                imageUrl,
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
}

