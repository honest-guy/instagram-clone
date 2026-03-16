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

  // Logic: Bottom Nav Index
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // In HomeScreen initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PostProvider>();
      // Use a slight delay to let the Shimmer draw first
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<PostProvider>().initLoad();
        }
      });
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<PostProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 1200 &&
        !provider.isLoading &&
        provider.posts.isNotEmpty) {
      // NEW: Only prefetch the new batch
      provider.loadMorePosts().then((_) {
        // Assuming loadMorePosts updates a 'newPosts' property or you calculate the delta
        final newPosts = provider.posts.skip(provider.posts.length - 10); // Adjust '10' to your batch size
        _prefetchImages(newPosts.toList());
    });
    }
  }

  void _prefetchImages(List<Post> posts) {
    for (var post in posts) {
      for (var image in post.images) {
        precacheImage(CachedNetworkImageProvider(image), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: _selectedIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Instagram",
          style: TextStyle(
            fontFamily: "Grandista", // Matches the 'family' name in your pubspec.yaml
            fontSize: 24,           // Increased slightly to match IG's real scale
            color: Colors.black,
            // Note: Removed FontWeight.bold to keep the font's natural curves
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ) : null, // Hide AppBar on other tabs for a clean look

      // Logic: Use IndexedStack to keep scroll position alive when switching tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFeedBody(provider), // Tab 0: The Feed
          const Center(child: Text("Search")), // Tab 1
          const Center(child: Text("Add Post")), // Tab 2
          const Center(child: Text("Reels")), // Tab 3
          const Center(child: Text("Profile")), // Tab 4
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/logo.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 2 ? Colors.black : Colors.black54,
            ),
              label: "Profile",
            ),

            /// ASSET ICON EXAMPLE
            /// Change 'assets/icons/reels.png' to your actual file path
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/share.png', //
                width: 48,
                height: 48,
                color: _selectedIndex == 2 ? Colors.black : Colors.black54,
              ),
              label: "Reels",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search_outlined),
              label: "Activity",
            ),

            // Mirror Test: Instagram uses a tiny avatar for the profile tab
            const BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 14,
                backgroundImage: CachedNetworkImageProvider(
                    "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=200"
                ),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  // Refactored Feed Logic for Clean Architecture
  Widget _buildFeedBody(PostProvider provider) {
    if (provider.posts.isEmpty && provider.isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => const ShimmerPost(),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      addAutomaticKeepAlives: false, // Critical for low-end devices
      addRepaintBoundaries: true,
      cacheExtent: 600,
      physics: const BouncingScrollPhysics(),
      itemCount: provider.posts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const StoriesRow();
        final post = provider.posts[index - 1];
        return RepaintBoundary(
          child: PostCard(post: post),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}