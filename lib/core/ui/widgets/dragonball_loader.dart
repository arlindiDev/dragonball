import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/colors.dart';

class DragonBallLoader extends StatefulWidget {
  final double size;

  const DragonBallLoader({
    super.key,
    this.size = 80,
  });

  @override
  State<DragonBallLoader> createState() => _DragonBallLoaderState();
}

class _DragonBallLoaderState extends State<DragonBallLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size * 1.5,
              height: widget.size * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Image.asset(
                  'assets/images/dragonball.png',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            Shimmer.fromColors(
              baseColor: Colors.white.withValues(alpha: 0.0),
              highlightColor: Colors.white.withValues(alpha: 0.5),
              period: const Duration(milliseconds: 1000),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
