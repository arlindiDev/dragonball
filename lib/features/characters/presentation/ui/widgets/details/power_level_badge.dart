import 'package:flutter/material.dart';

class PowerLevelBadge extends StatelessWidget {
  final String ki;
  final String maxKi;
  final List<Color> gradientColors;
  final Animation<double> glowAnimation;

  const PowerLevelBadge({
    super.key,
    required this.ki,
    required this.maxKi,
    required this.gradientColors,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final hasKi = ki != '0';
    final kiValue = hasKi ? ki : 'UNKNOWN';
    
    return Center(
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: gradientColors[1].withValues(alpha: glowAnimation.value * 0.7),
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
                    if (maxKi != '0')
                      Text(
                        'MAX: $maxKi',
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
}

