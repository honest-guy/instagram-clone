import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Match the vertical spacing of your real PostCard
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. HEADER (Avatar & Username)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                  const SizedBox(width: 10),
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            /// 2. IMAGE PLACEHOLDER (Pixel-Perfect Aspect Ratio)
            Container(
              height: 400, // Matches the standard IG post height
              width: double.infinity,
              color: Colors.white,
            ),

            /// 3. ACTION BAR (Like, Comment, Share, Save)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _shimmerCircle(24),
                  const SizedBox(width: 16),
                  _shimmerCircle(24),
                  const SizedBox(width: 16),
                  _shimmerCircle(24),
                  const Spacer(),
                  _shimmerCircle(24),
                ],
              ),
            ),

            /// 4. LIKES & CAPTION PLACEHOLDER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 10,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}