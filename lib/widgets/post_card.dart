import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PageController _pageController = PageController();
  // Using a TransformationController for "Pinch-to-Zoom" animation back to original
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    // Logic Update: Use 'watch' inside build for stateful interactions (Like/Save).
    // This ensures the widget rebuilds instantly when the heart icon is toggled.
    final provider = context.watch<PostProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// USER HEADER
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.post.avatarUrl),
          ),
          title: Text(
            widget.post.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Follow"),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        /// IMAGE CAROUSEL
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.post.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      provider.toggleLike(widget.post);
                    },
                    child: InteractiveViewer(
                      // Logic Update: Advanced Media Handling
                      // clipBehavior: Clip.none allows zoom to 'break' boundaries
                      clipBehavior: Clip.none,
                      transformationController: _transformationController,
                      minScale: 1,
                      maxScale: 4,
                      onInteractionEnd: (details) {
                        // REQUIREMENT: Animate back to original position on release
                        _transformationController.value = Matrix4.identity();
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.post.images[index],
                        fit: BoxFit.cover,
                        // Tell Flutter to decode a tiny version of the image for the feed
                        memCacheWidth: 350,
                        memCacheHeight: 350,
                        maxWidthDiskCache: 400,
                        filterQuality: FilterQuality.none,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// DOT INDICATOR
            if (widget.post.images.length > 1)
              Positioned(
                bottom: 10,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.post.images.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.white,
                  ),
                ),
              )
          ],
        ),

        /// ACTION BUTTONS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              /// LIKE
              IconButton(
                icon: Icon(
                  widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: widget.post.isLiked ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  // Calls provider to toggle the local state
                  provider.toggleLike(widget.post);
                },
              ),

              /// COMMENT
              IconButton(
                icon: Image.asset(
                  'assets/icons/comment.png',
                  width: 24,
                  height: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  _showFeatureSnackbar(context, "Comments");
                },
              ),

              /// REPOST
              IconButton(
                icon: Image.asset(
                  'assets/icons/repost.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _showFeatureSnackbar(context, "Repost");
                },
              ),

              /// SHARE
              IconButton(
                icon: Image.asset(
                  'assets/icons/share.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _showFeatureSnackbar(context, "Share");
                },
              ),
              const Spacer(),

              /// SAVE
              IconButton(
                icon: Icon(
                  widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () {
                  provider.toggleSave(widget.post);
                },
              )
            ],
          ),
        ),

        /// CAPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "${widget.post.username} ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.post.caption)
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // Helper method for clean architecture (Persistent Snackbar Requirement)
  void _showFeatureSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature not implemented"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}