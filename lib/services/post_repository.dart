import 'dart:async';
import '../models/post.dart';

class PostRepository {
  // REQUIREMENT: High-quality public URL.
  // We use one single URL for EVERYTHING to meet your request.
  static const String _heroImageUrl = "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1000";

  /// REQUIREMENT: Force 1.5-second delay to demonstrate Loading State (Shimmer)
  Future<List<Post>> fetchPosts({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    return List.generate(10, (index) {
      final postId = "post_${page}_$index";

      // LOGIC: Even-indexed posts remain Carousels to meet the "Advanced Media" requirement.
      // We pass the same URL 3 times to simulate a carousel.
      final bool isCarousel = index % 2 == 0;

      return Post(
        id: postId,
        username: "user_${page}_$index",

        // Use the single image for the Avatar
        avatarUrl: _heroImageUrl,

        // If it's a carousel, we send a list with the same URL repeated.
        // This tests your PageView and Dot Indicator logic perfectly.
        images: isCarousel
            ? [_heroImageUrl, _heroImageUrl, _heroImageUrl]
            : [_heroImageUrl],

        caption: "Living Happy Life",

        /// REQUIREMENT: Stateful Interactions (Initial states)
        isLiked: false,
        isSaved: false,
        likeCount: (index + 1) * 12,
      );
    });
  }
}