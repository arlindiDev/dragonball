import 'package:flutter/material.dart';

class EnergyRingsPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  EnergyRingsPainter(this.animationValue, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final phase = (animationValue + i * 0.33) % 1.0;
      final radius = (size.width / 2) * (0.5 + phase * 0.5);
      final opacity = (1.0 - phase) * 0.5;
      
      paint.color = colors[i % colors.length].withValues(alpha: opacity);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(EnergyRingsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

