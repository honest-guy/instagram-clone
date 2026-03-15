import 'package:flutter/material.dart';

class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Stack(
            children: [

              const CircleAvatar(
                radius: 32,
                backgroundImage:
                NetworkImage("https://i.pravatar.cc/150"),
              ),

              Positioned(
                bottom: 0,
                right: 0,
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
              )
            ],
          ),
          const SizedBox(height: 6),
          const Text("Your Story", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _storyItem(int index) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.orange,
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:
              NetworkImage("https://i.pravatar.cc/150?img=$index"),
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