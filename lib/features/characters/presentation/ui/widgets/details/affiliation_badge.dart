import 'package:flutter/material.dart';
import '../../../../../../core/ui/theme/colors.dart';

class AffiliationBadge extends StatelessWidget {
  final String affiliation;

  const AffiliationBadge({
    super.key,
    required this.affiliation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getAffiliationColors(affiliation),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getAffiliationColors(affiliation)[0]
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
              _getAffiliationIcon(affiliation),
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              affiliation.toUpperCase(),
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

  List<Color> _getAffiliationColors(String affiliation) {
    final lowerAffiliation = affiliation.toLowerCase();
    if (lowerAffiliation.contains('z fighter') || lowerAffiliation.contains('z-fighter')) {
      return AppColors.gradientBlue;
    } else if (lowerAffiliation.contains('army') || lowerAffiliation.contains('frieza')) {
      return AppColors.gradientPurple;
    } else if (lowerAffiliation.contains('freelancer')) {
      return AppColors.gradientGreen;
    } else if (lowerAffiliation.contains('red ribbon')) {
      return AppColors.gradientRed;
    } else {
      return [Colors.grey[700]!, Colors.grey[600]!];
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
}

