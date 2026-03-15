import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 50, color: Colors.white),
            Container(height: 300, color: Colors.white),
            Container(height: 50, color: Colors.white),
            ListTile(
              leading: const CircleAvatar(radius: 20, backgroundColor: Colors.white),
              title: Container(
                height: 12,
                width: 100,
                color: Colors.white,
              ),
            ),

            /// image placeholder
            Container(
              height: 350,
              color: Colors.white,
            ),

            const SizedBox(height: 10),

            /// caption placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 10,
                width: 200,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}