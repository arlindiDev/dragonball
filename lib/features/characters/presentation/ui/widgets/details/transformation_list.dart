import 'package:flutter/material.dart';
import '../../../../../../core/ui/theme/colors.dart';
import '../../../../domain/entities/transformation.dart';

class TransformationList extends StatelessWidget {
  final List<Transformation> transformations;
  final Animation<double> glowAnimation;

  const TransformationList({
    super.key,
    required this.transformations,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (transformations.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transformations
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final transformation = entry.value;
        return _buildTransformationCard(context, index, transformation);
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildTransformationCard(
    BuildContext context,
    int index,
    Transformation transformation,
  ) {
    final transformationColor = AppColors.getTransformationColor(index);
    
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(
            bottom: index < transformations.length - 1 ? 12.0 : 0,
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
                    .withValues(alpha: glowAnimation.value * 0.4),
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
}

