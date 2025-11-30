import 'package:flutter/material.dart';
import '../../../../../core/ui/theme/colors.dart';

class EnergyParticlesPainter extends CustomPainter {
  final double animationValue;

  EnergyParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final colors = [
      AppColors.orange.withValues(alpha: 0.3),
      AppColors.blue.withValues(alpha: 0.3),
      AppColors.purple.withValues(alpha: 0.3),
      AppColors.green.withValues(alpha: 0.3),
    ];

    const particleCount = 20;
    const baseRadius = 2.0;
    const radiusVariation = 1.5;
    const horizontalSpacing = 100;
    
    for (int i = 0; i < particleCount; i++) {
      final offset = (animationValue + i * 0.05) % 1.0;
      final x = (i * horizontalSpacing) % size.width;
      final y = size.height * offset;
      final radius = baseRadius + (i % 3) * radiusVariation;
      
      paint.color = colors[i % colors.length];
      
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    for (int i = 0; i < 5; i++) {
      final lineOffset = (animationValue * 2 + i * 0.2) % 2.0;
      final startX = size.width * lineOffset - size.width;
      final startY = 0.0;
      final endX = size.width * lineOffset;
      final endY = size.height;
      
      paint.color = colors[i % colors.length].withValues(alpha: 0.05);
      paint.strokeWidth = 2;
      paint.style = PaintingStyle.stroke;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(EnergyParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

