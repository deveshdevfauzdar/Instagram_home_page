import 'package:flutter/material.dart';

import '../../domain/models/story.dart';
import 'network_image_tile.dart';

class StoriesTray extends StatelessWidget {
  const StoriesTray({super.key, required this.stories});

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF262626), width: 0.8),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemBuilder: (BuildContext context, int index) {
          final Story story = stories[index];
          return SizedBox(
            width: 74,
            child: Column(
              children: <Widget>[
                _StoryAvatar(story: story),
                const SizedBox(height: 6),
                Text(
                  story.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.1,
                    color: Color(0xFFF5F5F5),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 6),
        itemCount: stories.length,
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(2.2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: story.isSeen
            ? const LinearGradient(
                colors: <Color>[Color(0xFF5F6368), Color(0xFF5F6368)],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  Color(0xFFFED33B),
                  Color(0xFFF77737),
                  Color(0xFFE1306C),
                  Color(0xFFC13584),
                ],
              ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF000000),
        ),
        padding: const EdgeInsets.all(2.4),
        child: ClipOval(
          child: AspectRatio(
            aspectRatio: 1,
            child: NetworkImageTile(imageUrl: story.avatarUrl),
          ),
        ),
      ),
    );
  }
}
