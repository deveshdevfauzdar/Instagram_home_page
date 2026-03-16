import 'package:flutter_test/flutter_test.dart';

import 'package:instagram_pixel_feed/src/features/feed/domain/models/post.dart';

void main() {
  test('Post copyWith updates like and save state', () {
    const Post post = Post(
      id: '1',
      username: 'user',
      userAvatarUrl: 'https://example.com/avatar.jpg',
      location: 'Location',
      mediaUrls: <String>['https://example.com/pic.jpg'],
      caption: 'Caption',
      likeCount: 10,
      likedBy: 'another',
      timeAgo: '2h',
    );

    final Post updated = post.copyWith(
      isLiked: true,
      isSaved: true,
      likeCount: 11,
    );

    expect(updated.isLiked, isTrue);
    expect(updated.isSaved, isTrue);
    expect(updated.likeCount, 11);
  });
}
