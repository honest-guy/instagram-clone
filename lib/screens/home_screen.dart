import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/shimmer_post.dart';
import '../widgets/story_item.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final provider = Provider.of<PostProvider>(context, listen: false);

      provider.loadPosts().then((_) {
        _prefetchImages(provider.posts);
      });

    });

    _scrollController.addListener(() {

      final provider = Provider.of<PostProvider>(context, listen: false);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !provider.isLoadingMore) {

        provider.loadPosts().then((_) {
          _prefetchImages(provider.posts);
        });

      }

    });
  }

  void _prefetchImages(List<Post> posts) {

    for (var post in posts) {

      for (var image in post.images) {

        precacheImage(
          CachedNetworkImageProvider(image),
          context,
        );

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<PostProvider>();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Instagram",
            style: TextStyle(
              fontFamily: "Billabong",
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ],
        ),

        body: provider.posts.isEmpty && provider.isLoading
            ? ListView.builder(
          itemCount: 5,
          itemBuilder: (_, _) => const ShimmerPost(),
        )
            : ListView.builder(
          controller: _scrollController,
          cacheExtent: 1200,
          physics: const BouncingScrollPhysics(),
          itemCount: provider.posts.length + 1 + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {

            /// 1️⃣ STORIES ROW
            if (index == 0) {
              return const StoriesRow();
            }

            /// adjust index because stories occupy position 0
            final postIndex = index - 1;

            /// 2️⃣ POSTS
            if (postIndex < provider.posts.length) {

              final post = provider.posts[postIndex];

              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(post: post),
                ),
              );
            }

            /// 3️⃣ PAGINATION LOADER
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}