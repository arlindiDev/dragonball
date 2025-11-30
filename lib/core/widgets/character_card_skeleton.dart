import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading skeleton for the character card
class CharacterCardSkeleton extends StatelessWidget {
  const CharacterCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        height: 260,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image skeleton - takes most of the space
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[850]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[850],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Name skeleton - centered at bottom
            Shimmer.fromColors(
              baseColor: Colors.grey[850]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                height: 24,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[850],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
