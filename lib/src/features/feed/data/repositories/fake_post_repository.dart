import 'dart:math';

import '../../domain/models/post.dart';
import '../../domain/models/story.dart';
import '../../domain/repositories/post_repository.dart';

class FakePostRepository implements PostRepository {
  static const int maxPosts = 120;

  static const List<String> _usernames = <String>[
    'kylemason',
    'mari.sounds',
    'the_wildframe',
    'nina.designs',
    'travelingnoah',
    'pixeljournal',
    'city.vibes',
    'moodylights',
    'chasinggold',
    'daily.texture',
  ];

  static const List<String> _locations = <String>[
    'New York, USA',
    'Tokyo, Japan',
    'Barcelona, Spain',
    'Lagos, Nigeria',
    'Seoul, South Korea',
    'Copenhagen, Denmark',
    'Lisbon, Portugal',
  ];

  static const List<String> _captions = <String>[
    'Golden hour never misses.',
    'Mood board from this weekend.',
    'A little stillness between the rush.',
    'Frames from today. Which one is your favorite?',
    'Light, texture, and quiet corners.',
    'Scenes that felt like a movie.',
    'Color study from the city walk.',
  ];

  static const List<String> _images = <String>[
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1464863979621-258859e62245?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1495385794356-15371f348c31?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1519999482648-25049ddd37b1?auto=format&fit=crop&w=1200&q=80',
  ];

  @override
  Future<List<Post>> fetchPosts({required int page, required int limit}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final int start = page * limit;
    if (start >= maxPosts) {
      return const <Post>[];
    }

    final int endExclusive = min(start + limit, maxPosts);

    return List<Post>.generate(endExclusive - start, (int index) {
      final int postIndex = start + index;
      final int seed = postIndex % _usernames.length;
      final int imageSeed = postIndex % _images.length;
      final bool useCarousel = postIndex % 3 == 0;

      final List<String> mediaUrls = useCarousel
          ? <String>[
              _images[imageSeed],
              _images[(imageSeed + 1) % _images.length],
              _images[(imageSeed + 2) % _images.length],
            ]
          : <String>[_images[imageSeed]];

      return Post(
        id: 'post_$postIndex',
        username: _usernames[seed],
        userAvatarUrl: _images[(imageSeed + 3) % _images.length],
        location: _locations[postIndex % _locations.length],
        mediaUrls: mediaUrls,
        caption: _captions[postIndex % _captions.length],
        likeCount: 320 + (postIndex * 7),
        likedBy: _usernames[(seed + 1) % _usernames.length],
        timeAgo: '${(postIndex % 10) + 1}h',
      );
    });
  }

  @override
  Future<List<Story>> fetchStories() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    return List<Story>.generate(12, (int index) {
      return Story(
        id: 'story_$index',
        username: _usernames[index % _usernames.length],
        avatarUrl: _images[(index + 4) % _images.length],
        isSeen: index > 3,
      );
    });
  }
}
