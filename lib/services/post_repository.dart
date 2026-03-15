import 'dart:async';
import '../models/post.dart';

class PostRepository {

  Future<List<Post>> fetchPosts(int page) async {

    await Future.delayed(const Duration(milliseconds: 1500));

    List<String> images = [
      "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d",
      "https://images.unsplash.com/photo-1492724441997-5dc865305da7",
      "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e"
    ];

    return List.generate(10, (index) {

      return Post(
        id: "post_${page}_$index",
        username: "user_${page}_$index",
        avatarUrl:
        "https://i.pravatar.cc/150?img=${(page * 10) + index}",
        images: images,
        caption: "Beautiful day at the beach 🌊",
      );
    });
  }
}