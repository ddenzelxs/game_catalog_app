import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Fake image
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

            const SizedBox(height: 12),

            // 🔹 Fake title
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 14,
              width: double.infinity,
              color: Colors.black,
            ),

            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 14,
              width: 80,
              color: Colors.black,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}