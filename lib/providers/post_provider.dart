import 'package:flutter/material.dart';
import 'dart:isolate'; // Added for background parsing if needed
import '../models/post.dart';
import '../services/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository = PostRepository();

  List<Post> posts = [];
  bool isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true; // Prevents unnecessary calls if API is empty

  Future<void> initLoad() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      posts = await _repository.fetchPosts(page: _currentPage);
    } catch (e) {
      debugPrint("Error loading posts: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    // CRITICAL FIX: Block multiple simultaneous calls
    if (isLoading || !_hasMore) return;

    isLoading = true;
    notifyListeners(); // This tells the UI to stop calling this method

    try {
      _currentPage++;
      final newPosts = await _repository.fetchPosts(page: _currentPage);

      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        posts.addAll(newPosts);
      }
    } catch (e) {
      _currentPage--; // Reset page on failure
      debugPrint("Error loading more posts: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Optimization: Only update the specific post instead of the whole list
  void toggleLike(Post post) {
    post.isLiked = !post.isLiked;
    notifyListeners();
  }

  void toggleSave(Post post) {
    post.isSaved = !post.isSaved;
    notifyListeners();
  }
}
