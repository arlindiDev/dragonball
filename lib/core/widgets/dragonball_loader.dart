import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DragonBallLoader extends StatelessWidget {
  final double size;

  const DragonBallLoader({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/dragonball.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.0),
          highlightColor: Colors.white.withValues(alpha: 0.4),
          period: const Duration(milliseconds: 1500),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
