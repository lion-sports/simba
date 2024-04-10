import 'package:flutter/material.dart';

class Post {
  final String mediaUrl; // Video or image URL
  final String description;
  int likes;
  int comments;
  int shares;

  Post({
    required this.mediaUrl,
    required this.description,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Post Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Image or Video
          AspectRatio(
            aspectRatio: 16 / 9, // Adjust this ratio based on your media type
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post.mediaUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              post.description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.thumb_up),
              onPressed: () {
                // Handle like functionality
                // You can update the likes count and perform other actions here
              },
            ),
            IconButton(
              icon: const Icon(Icons.comment),
              onPressed: () {
                // Handle comment functionality
                // You can navigate to the comment section or display a modal for comments
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Handle share functionality
                // You can implement sharing options, e.g., share to other apps
              },
            ),
          ],
        ),
      ),
    );
  }
}
