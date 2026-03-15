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
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    final provider = context.read<PostProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// USER HEADER
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
            CachedNetworkImageProvider(widget.post.avatarUrl),
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
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                  itemBuilder: (context, index) {

                    return GestureDetector(
                      onDoubleTap: () {
                        provider.toggleLike(widget.post);
                      },
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: CachedNetworkImage(
                          imageUrl: widget.post.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          memCacheWidth: 800,
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    );
                  }
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [

              /// LIKE
              IconButton(
                icon: Icon(
                  widget.post.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                  widget.post.isLiked ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  provider.toggleLike(widget.post);
                },
              ),
              /// COMMENT
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Comments not implemented"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              /// SHARE
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Share not implemented"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const Spacer(),

              /// SAVE
              IconButton(
                icon: Icon(
                  widget.post.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
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
}