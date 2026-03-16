class Post {
  final String id;
  final String username;
  final String avatarUrl;
  final List<String> images;
  final String caption;
  final int likeCount; // Added for the "Mirror Test" (IG shows like counts)

  // Note: For Clean Architecture, many pros keep these final and use copyWith,
  // but keeping them as non-final bools is fine for this 8-10 hour challenge.
  bool isLiked;
  bool isSaved;

  Post({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.images,
    required this.caption,
    this.likeCount = 0,
    this.isLiked = false,
    this.isSaved = false,
  });

  // Pro-Tip: Adding a copyWith method shows "Senior Level" thinking.
  // It allows you to create a new version of the post with one change.
  Post copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
  }) {
    return Post(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      images: images,
      caption: caption,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}