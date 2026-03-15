import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_repository.dart';

class PostProvider extends ChangeNotifier {

  List<Post> posts = [];

  bool isLoading = false;
  bool isLoadingMore = false;

  Future<void> loadPosts() async {
    if (isLoadingMore) return;

    isLoadingMore = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    posts.addAll(generateMorePosts());

    isLoadingMore = false;
    notifyListeners();
  }

  List<Post> generateMorePosts() {

    return List.generate(5, (index) {

      final id = (posts.length + index).toString();

      return Post(
        id: id,
        username: "user_$id",
        avatarUrl: "https://i.pravatar.cc/150?img=$id",
        caption: "Beautiful day! ☀️ #flutter",
        images: [
          "https://picsum.photos/500/500?random=$id",
          "https://picsum.photos/500/500?random=${posts.length + index + 1}"
        ],
        isLiked: false,
        isSaved: false,
      );
    });
  }

  void toggleLike(Post post) {
    post.isLiked = !post.isLiked;
    notifyListeners();
  }

  void toggleSave(Post post) {
    post.isSaved = !post.isSaved;
    notifyListeners();
  }
}