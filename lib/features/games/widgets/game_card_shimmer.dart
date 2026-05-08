import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E1E),
      highlightColor: const Color(0xFF2A2A2A),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}