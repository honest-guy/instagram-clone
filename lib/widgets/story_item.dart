import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  // REQUIREMENT: High-quality public URL.
  // We use the exact same single image URL used in your PostRepository for consistency.
  // Adding '&w=800' tells the server to resize the image BEFORE sending it to you
  static const String _heroImageUrl = "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=600";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      // Mirror Test: subtle bottom border like the real IG app
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _yourStory();
          }
          return _storyItem(index);
        },
      ),
    );
  }

  Widget _yourStory() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Colors.grey,
                // Using CachedNetworkImageProvider for "Elite" memory handling
                backgroundImage: CachedNetworkImageProvider(_heroImageUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          const Text("Your story", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _storyItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // The colorful Instagram border
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF833AB4), // Purple
                  Color(0xFFFD1D1D), // Red
                  Color(0xFFFCAF45), // Orange/Yellow
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(3), // The "White Gap" for pixel-perfection
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade200,
                // Same single image used for all users as per your strategy
                backgroundImage: CachedNetworkImageProvider(_heroImageUrl),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "user$index",
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}